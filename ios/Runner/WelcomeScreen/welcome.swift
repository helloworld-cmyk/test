//
//  welcome.swift
//  Runner
//
//  Created by Phong on 13/3/26.
//

import SwiftUI

struct ProductScreen: View {
    private let fullName: String
    private let email: String

    @State private var products: [Product] = allProducts
    @State private var pageIndex: Int = 0

    private let itemsPerPage: Int = 3

    init(fullName: String, email: String) {
        self.fullName = fullName
        self.email = email
    }

    private var productPages: [[Product]] {
        guard !products.isEmpty else { return [] }
        var pages: [[Product]] = []
        var start = 0
        while start < products.count {
            let end = min(start + itemsPerPage, products.count)
            pages.append(Array(products[start..<end]))
            start = end
        }
        return pages
    }

    private var currentPageProducts: [Product] {
        guard !productPages.isEmpty else { return [] }
        let safeIndex = max(0, min(pageIndex, productPages.count - 1))
        return productPages[safeIndex]
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.96, green: 0.97, blue: 1.0), Color.white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .font(.system(size: 54, weight: .semibold))
                            .foregroundColor(.blue)
                            .padding(.bottom, 4)

                        Text("Xin chào, \(fullName)")
                            .font(.system(size: 28, weight: .bold))
                            .multilineTextAlignment(.center)

                        Text(email)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 16)

                    if currentPageProducts.isEmpty {
                        Text("Không có sản phẩm")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 36)
                            .background(Color(red: 0.95, green: 0.96, blue: 0.98))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    } else {
                        VStack(spacing: 12) {
                            ForEach(currentPageProducts) { product in
                                ProductItemView(product: product)
                            }
                        }
                    }

                    if productPages.count > 0 {
                        HStack(spacing: 12) {
                            Button(action: decrementPage) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                    .frame(width: 36, height: 36)
                                    .background(pageIndex == 0 ? Color.gray.opacity(0.2) : Color.blue)
                                    .foregroundColor(pageIndex == 0 ? .gray : .white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                            .disabled(pageIndex == 0)

                            Text("Page \(pageIndex + 1)/\(productPages.count)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)

                            Button(action: incrementPage) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .frame(width: 36, height: 36)
                                    .background(pageIndex >= productPages.count - 1 ? Color.gray.opacity(0.2) : Color.blue)
                                    .foregroundColor(pageIndex >= productPages.count - 1 ? .gray : .white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            }
                            .disabled(pageIndex >= productPages.count - 1)
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.08), radius: 24, y: 10)
                )
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .pullToRefreshCompat {
                refreshProducts()
            }
        }
    }

    private func incrementPage() {
        let maxIndex = max(0, productPages.count - 1)
        if pageIndex < maxIndex {
            pageIndex += 1
        }
    }

    private func decrementPage() {
        if pageIndex > 0 {
            pageIndex -= 1
        }
    }

    private func refreshProducts() {
        withAnimation(.easeInOut(duration: 0.2)) {
            products.shuffle()
            pageIndex = 0
        }
    }
}

struct ProductItemView: View {
    let product: Product

    var body: some View {
        HStack(spacing: 12) {
            RemoteImage(urlString: product.image)
                .frame(width: 92, height: 92)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text("ID: \(product.id)")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)

                Text(product.name)
                    .font(.system(size: 16, weight: .bold))

                Text("Giá: \(product.price)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.blue)
            }

            Spacer()
        }
        .padding(12)
        .background(Color(red: 0.95, green: 0.96, blue: 0.98))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct RemoteImage: View {
    let urlString: String

    @State private var image: UIImage? = nil

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            }
        }
        .clipped()
        .onAppear(perform: loadImage)
    }

    private func loadImage() {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let uiImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = uiImage
            }
        }
        task.resume()
    }
}

struct Product: Identifiable {
    let id: Int
    let name: String
    let price: String
    let image: String
}

let allProducts: [Product] = [
    Product(id: 1, name: "Tai nghe Bluetooth", price: "590.000đ", image: "https://picsum.photos/seed/p1/480/320"),
    Product(id: 2, name: "Bàn phím cơ", price: "1.290.000đ", image: "https://picsum.photos/seed/p2/480/320"),
    Product(id: 3, name: "Chuột không dây", price: "420.000đ", image: "https://picsum.photos/seed/p3/480/320"),
    Product(id: 4, name: "Màn hình 24 inch", price: "3.450.000đ", image: "https://picsum.photos/seed/p4/480/320"),
    Product(id: 5, name: "Webcam HD", price: "790.000đ", image: "https://picsum.photos/seed/p5/480/320"),
    Product(id: 6, name: "Giá đỡ laptop", price: "350.000đ", image: "https://picsum.photos/seed/p6/480/320"),
    Product(id: 7, name: "Sạc nhanh 65W", price: "490.000đ", image: "https://picsum.photos/seed/p7/480/320"),
    Product(id: 8, name: "Loa mini", price: "560.000đ", image: "https://picsum.photos/seed/p8/480/320"),
    Product(id: 9, name: "Ổ cứng SSD 1TB", price: "1.890.000đ", image: "https://picsum.photos/seed/p9/480/320"),
    Product(id: 10, name: "Đèn bàn LED", price: "310.000đ", image: "https://picsum.photos/seed/p10/480/320")
]

private extension View {
    @ViewBuilder
    func pullToRefreshCompat(action: @escaping () -> Void) -> some View {
        if #available(iOS 15.0, *) {
            self.refreshable {
                action()
            }
        } else {
            self
        }
    }
}
