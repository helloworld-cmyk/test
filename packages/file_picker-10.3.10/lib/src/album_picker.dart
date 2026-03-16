import 'file_picker.dart';
import 'platform_file.dart';

enum AlbumPickRejectReason {
  tooLarge,
  tooMany,
  unsupportedExtension,
  missingBytes,
}

class AlbumPickRejection {
  const AlbumPickRejection({
    required this.name,
    required this.size,
    required this.reason,
    this.details,
  });

  final String name;
  final int size;
  final AlbumPickRejectReason reason;
  final String? details;
}

class AlbumPickResult {
  const AlbumPickResult({
    required this.accepted,
    required this.rejected,
  });

  final List<PlatformFile> accepted;
  final List<AlbumPickRejection> rejected;

  int get acceptedCount => accepted.length;
  int get rejectedCount => rejected.length;
  bool get hasRejections => rejected.isNotEmpty;
}

extension AlbumPicker on FilePicker {
  Future<AlbumPickResult?> pickAlbumImages({
    int maxCount = 50,
    int maxSizeMB = 10,
    List<String>? allowedExtensions,
    bool withData = true,
    bool withReadStream = false,
    Function(FilePickerStatus)? onFileLoading,
  }) async {
    final normalized = _normalizeExtensions(allowedExtensions);
    final useCustom = normalized.isNotEmpty;

    final result = await pickFiles(
      type: useCustom ? FileType.custom : FileType.image,
      allowedExtensions: useCustom ? normalized : null,
      allowMultiple: true,
      withData: withData,
      withReadStream: withReadStream,
      onFileLoading: onFileLoading,
    );

    if (result == null) return null;

    final accepted = <PlatformFile>[];
    final rejected = <AlbumPickRejection>[];
    final int maxBytes =
        maxSizeMB > 0 ? maxSizeMB * 1024 * 1024 : 0;

    for (final file in result.files) {
      if (maxCount > 0 && accepted.length >= maxCount) {
        rejected.add(
          AlbumPickRejection(
            name: file.name,
            size: file.size,
            reason: AlbumPickRejectReason.tooMany,
          ),
        );
        continue;
      }

      if (useCustom) {
        final ext = _extensionFromName(file.name);
        if (ext == null || !normalized.contains(ext)) {
          rejected.add(
            AlbumPickRejection(
              name: file.name,
              size: file.size,
              reason: AlbumPickRejectReason.unsupportedExtension,
              details: ext ?? 'none',
            ),
          );
          continue;
        }
      }

      if (maxBytes > 0 && file.size > maxBytes) {
        rejected.add(
          AlbumPickRejection(
            name: file.name,
            size: file.size,
            reason: AlbumPickRejectReason.tooLarge,
          ),
        );
        continue;
      }

      if (withData && file.bytes == null) {
        rejected.add(
          AlbumPickRejection(
            name: file.name,
            size: file.size,
            reason: AlbumPickRejectReason.missingBytes,
          ),
        );
        continue;
      }

      accepted.add(file);
    }

    return AlbumPickResult(accepted: accepted, rejected: rejected);
  }
}

String? _extensionFromName(String name) {
  final dotIndex = name.lastIndexOf('.');
  if (dotIndex <= 0 || dotIndex >= name.length - 1) return null;
  return name.substring(dotIndex + 1).toLowerCase();
}

List<String> _normalizeExtensions(List<String>? extensions) {
  if (extensions == null || extensions.isEmpty) return <String>[];
  final normalized = <String>[];
  for (final ext in extensions) {
    final value = ext.trim().toLowerCase().replaceAll('.', '');
    if (value.isEmpty) continue;
    if (!normalized.contains(value)) normalized.add(value);
  }
  return normalized;
}
