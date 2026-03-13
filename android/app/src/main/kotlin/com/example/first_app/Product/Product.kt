package com.example.first_app

import android.content.Context
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.text.TextUtils
import android.view.Gravity
import android.view.View
import android.widget.Button
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import java.net.HttpURLConnection
import java.net.URL

class ProductScreenView(
	context: Context,
	fullName: String,
	email: String
) : FrameLayout(context) {

	private val products = allProducts.toMutableList()
	private var pageIndex = 0
	private val itemsPerPage = 3

	private val swipeRefreshLayout = SwipeRefreshLayout(context)
	private val productListContainer = LinearLayout(context)
	private val pageLabel = TextView(context)
	private val prevButton = Button(context)
	private val nextButton = Button(context)

	init {
		background = GradientDrawable(
			GradientDrawable.Orientation.TL_BR,
			intArrayOf(0xFFF5F7FF.toInt(), 0xFFFFFFFF.toInt())
		)

		swipeRefreshLayout.setColorSchemeColors(0xFF2979FF.toInt())
		swipeRefreshLayout.setOnRefreshListener { refreshProducts() }

		val scrollView = ScrollView(context).apply {
			isFillViewport = true
			overScrollMode = OVER_SCROLL_ALWAYS
			isVerticalScrollBarEnabled = false
		}

		val contentWrapper = FrameLayout(context)
		scrollView.addView(
			contentWrapper,
			LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
		)

		val cardLayout = LinearLayout(context).apply {
			orientation = LinearLayout.VERTICAL
			setPadding(context.dp(24), context.dp(24), context.dp(24), context.dp(24))
			background = roundedDrawable(color = 0xFFFFFFFF.toInt(), radiusDp = 24f)
			elevation = context.dp(8).toFloat()
		}

		val cardParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT).apply {
			gravity = Gravity.CENTER_HORIZONTAL
			setMargins(context.dp(20), context.dp(24), context.dp(20), context.dp(24))
		}

		val iconLabel = TextView(context).apply {
			text = "👤"
			textSize = 48f
			gravity = Gravity.CENTER
		}

		val titleLabel = TextView(context).apply {
			text = "Xin chào, $fullName"
			textSize = 28f
			typeface = Typeface.DEFAULT_BOLD
			gravity = Gravity.CENTER_HORIZONTAL
			maxLines = 2
			ellipsize = TextUtils.TruncateAt.END
		}

		val emailLabel = TextView(context).apply {
			text = email
			textSize = 15f
			setTextColor(0xFF8B8B8B.toInt())
			gravity = Gravity.CENTER_HORIZONTAL
		}

		cardLayout.addView(iconLabel, linearParams(bottomDp = 8, gravity = Gravity.CENTER_HORIZONTAL))
		cardLayout.addView(titleLabel, linearParams(bottomDp = 4, gravity = Gravity.CENTER_HORIZONTAL))
		cardLayout.addView(emailLabel, linearParams(bottomDp = 20, gravity = Gravity.CENTER_HORIZONTAL))

		productListContainer.apply {
			orientation = LinearLayout.VERTICAL
		}
		cardLayout.addView(productListContainer)

		val pagerRow = LinearLayout(context).apply {
			orientation = LinearLayout.HORIZONTAL
			gravity = Gravity.CENTER
		}

		prevButton.apply {
			text = "<"
			textSize = 16f
			isAllCaps = false
			setTypeface(typeface, Typeface.BOLD)
			setPadding(0, context.dp(8), 0, context.dp(8))
			setOnClickListener {
				if (pageIndex > 0) {
					pageIndex -= 1
					renderProducts()
				}
			}
		}

		pageLabel.apply {
			textSize = 14f
			setTextColor(0xFF8B8B8B.toInt())
			setPadding(context.dp(12), 0, context.dp(12), 0)
		}

		nextButton.apply {
			text = ">"
			textSize = 16f
			isAllCaps = false
			setTypeface(typeface, Typeface.BOLD)
			setPadding(0, context.dp(8), 0, context.dp(8))
			setOnClickListener {
				val maxIndex = (productPages().size - 1).coerceAtLeast(0)
				if (pageIndex < maxIndex) {
					pageIndex += 1
					renderProducts()
				}
			}
		}

		pagerRow.addView(prevButton, LinearLayout.LayoutParams(context.dp(36), context.dp(36)))
		pagerRow.addView(pageLabel)
		pagerRow.addView(nextButton, LinearLayout.LayoutParams(context.dp(36), context.dp(36)))

		cardLayout.addView(pagerRow, linearParams(topDp = 12, gravity = Gravity.CENTER_HORIZONTAL))

		contentWrapper.addView(cardLayout, cardParams)
		swipeRefreshLayout.addView(scrollView)
		addView(swipeRefreshLayout, LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT))

		renderProducts()
	}

	private fun refreshProducts() {
		products.shuffle()
		pageIndex = 0
		renderProducts()
		swipeRefreshLayout.isRefreshing = false
	}

	private fun renderProducts() {
		val pages = productPages()
		val safeIndex = pageIndex.coerceIn(0, (pages.size - 1).coerceAtLeast(0))
		pageIndex = safeIndex

		productListContainer.removeAllViews()

		val currentProducts = if (pages.isEmpty()) emptyList() else pages[safeIndex]
		if (currentProducts.isEmpty()) {
			val emptyView = TextView(context).apply {
				text = "Không có sản phẩm"
				textSize = 15f
				setTextColor(0xFF8B8B8B.toInt())
				gravity = Gravity.CENTER
				setPadding(context.dp(12), context.dp(36), context.dp(12), context.dp(36))
				background = roundedDrawable(color = 0xFFF2F5FA.toInt(), radiusDp = 12f)
			}
			productListContainer.addView(emptyView)
		} else {
			currentProducts.forEach { product ->
				productListContainer.addView(createProductItemView(product))
			}
		}

		val totalPages = pages.size
		if (totalPages > 0) {
			pageLabel.text = "Page ${safeIndex + 1}/$totalPages"
		} else {
			pageLabel.text = "Page 0/0"
		}

		val atStart = safeIndex == 0
		val atEnd = safeIndex >= (totalPages - 1).coerceAtLeast(0)

		prevButton.isEnabled = !atStart && totalPages > 0
		nextButton.isEnabled = !atEnd && totalPages > 0

		prevButton.background = roundedDrawable(
			color = if (prevButton.isEnabled) 0xFF2979FF.toInt() else 0xFFDDDFE4.toInt(),
			radiusDp = 10f
		)
		nextButton.background = roundedDrawable(
			color = if (nextButton.isEnabled) 0xFF2979FF.toInt() else 0xFFDDDFE4.toInt(),
			radiusDp = 10f
		)
		prevButton.setTextColor(if (prevButton.isEnabled) Color.WHITE else 0xFF8B8B8B.toInt())
		nextButton.setTextColor(if (nextButton.isEnabled) Color.WHITE else 0xFF8B8B8B.toInt())
	}

	private fun createProductItemView(product: Product): View {
		val itemContainer = LinearLayout(context).apply {
			orientation = LinearLayout.HORIZONTAL
			gravity = Gravity.CENTER_VERTICAL
			setPadding(context.dp(12), context.dp(12), context.dp(12), context.dp(12))
			background = roundedDrawable(color = 0xFFF2F5FA.toInt(), radiusDp = 12f)
		}

		val itemParams = linearParams(bottomDp = 12)

		val imageView = ImageView(context).apply {
			scaleType = ImageView.ScaleType.CENTER_CROP
			background = roundedDrawable(color = 0xFFFFFFFF.toInt(), radiusDp = 10f)
			clipToOutline = true
		}

		val imageWrapper = FrameLayout(context).apply {
			background = roundedDrawable(color = 0xFFFFFFFF.toInt(), radiusDp = 10f)
			addView(
				imageView,
				LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
			)
		}

		val imageParams = LinearLayout.LayoutParams(context.dp(92), context.dp(92))
		itemContainer.addView(imageWrapper, imageParams)
		loadImageAsync(product.image, imageView)

		val textColumn = LinearLayout(context).apply {
			orientation = LinearLayout.VERTICAL
			setPadding(context.dp(12), 0, 0, 0)
		}

		val idLabel = TextView(context).apply {
			text = "ID: ${product.id}"
			textSize = 13f
			setTextColor(0xFF8B8B8B.toInt())
		}

		val nameLabel = TextView(context).apply {
			text = product.name
			textSize = 16f
			setTypeface(typeface, Typeface.BOLD)
			maxLines = 2
			ellipsize = TextUtils.TruncateAt.END
		}

		val priceLabel = TextView(context).apply {
			text = "Giá: ${product.price}"
			textSize = 14f
			setTextColor(0xFF2979FF.toInt())
			setTypeface(typeface, Typeface.BOLD)
		}

		textColumn.addView(idLabel)
		textColumn.addView(nameLabel, linearParams(topDp = 4))
		textColumn.addView(priceLabel, linearParams(topDp = 4))

		itemContainer.addView(
			textColumn,
			LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
		)

		itemContainer.layoutParams = itemParams
		return itemContainer
	}

	private fun productPages(): List<List<Product>> {
		if (products.isEmpty()) {
			return emptyList()
		}
		return products.chunked(itemsPerPage)
	}

	private fun linearParams(
		topDp: Int = 0,
		bottomDp: Int = 0,
		gravity: Int = Gravity.NO_GRAVITY
	): LinearLayout.LayoutParams {
		return LinearLayout.LayoutParams(
			LinearLayout.LayoutParams.MATCH_PARENT,
			LinearLayout.LayoutParams.WRAP_CONTENT
		).apply {
			if (topDp != 0 || bottomDp != 0) {
				setMargins(0, context.dp(topDp), 0, context.dp(bottomDp))
			}
			if (gravity != Gravity.NO_GRAVITY) {
				this.gravity = gravity
			}
		}
	}

	private fun roundedDrawable(color: Int, radiusDp: Float): GradientDrawable {
		return GradientDrawable().apply {
			shape = GradientDrawable.RECTANGLE
			cornerRadius = context.dpF(radiusDp)
			setColor(color)
		}
	}

	private fun loadImageAsync(urlString: String, imageView: ImageView) {
		Thread {
			val bitmap = runCatching {
				val connection = URL(urlString).openConnection() as HttpURLConnection
				connection.connectTimeout = 5000
				connection.readTimeout = 5000
				connection.doInput = true
				connection.connect()
				connection.inputStream.use { input ->
					BitmapFactory.decodeStream(input)
				}
			}.getOrNull()

			imageView.post {
				if (bitmap != null) {
					imageView.setImageBitmap(bitmap)
				} else {
					imageView.setBackgroundColor(0xFFE2E6EE.toInt())
				}
			}
		}.start()
	}
}

private data class Product(
	val id: Int,
	val name: String,
	val price: String,
	val image: String
)

private val allProducts = listOf(
	Product(1, "Tai nghe Bluetooth", "590.000đ", "https://picsum.photos/seed/p1/480/320"),
	Product(2, "Bàn phím cơ", "1.290.000đ", "https://picsum.photos/seed/p2/480/320"),
	Product(3, "Chuột không dây", "420.000đ", "https://picsum.photos/seed/p3/480/320"),
	Product(4, "Màn hình 24 inch", "3.450.000đ", "https://picsum.photos/seed/p4/480/320"),
	Product(5, "Webcam HD", "790.000đ", "https://picsum.photos/seed/p5/480/320"),
	Product(6, "Giá đỡ laptop", "350.000đ", "https://picsum.photos/seed/p6/480/320"),
	Product(7, "Sạc nhanh 65W", "490.000đ", "https://picsum.photos/seed/p7/480/320"),
	Product(8, "Loa mini", "560.000đ", "https://picsum.photos/seed/p8/480/320"),
	Product(9, "Ổ cứng SSD 1TB", "1.890.000đ", "https://picsum.photos/seed/p9/480/320"),
	Product(10, "Đèn bàn LED", "310.000đ", "https://picsum.photos/seed/p10/480/320")
)

private fun Context.dp(value: Int): Int {
	return (value * resources.displayMetrics.density).toInt()
}

private fun Context.dpF(value: Float): Float {
	return value * resources.displayMetrics.density
}
