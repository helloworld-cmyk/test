package com.example.first_app

import android.content.Context
import android.view.View
import android.widget.FrameLayout
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class ComposeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val params = args as? Map<*, *>
        val fullName = params?.get("fullName") as? String ?: "Guest"
        val email = params?.get("email") as? String ?: "guest@example.com"

        return ComposePlatformView(context, fullName, email)
    }
}

class ComposePlatformView(
    private val context: Context,
    defaultFullName: String,
    defaultEmail: String
) : PlatformView {

    private val rootContainer = FrameLayout(context)
    private var fullName: String = defaultFullName
    private var email: String = defaultEmail

    init {
        showLoginView()
    }

    override fun getView(): View {
        return rootContainer
    }

    override fun dispose() {
        rootContainer.removeAllViews()
    }

    private fun showLoginView() {
        val loginView = LoginScreenView(context) { loggedInFullName, loggedInEmail ->
            fullName = loggedInFullName
            email = loggedInEmail
            showProductView()
        }

        rootContainer.removeAllViews()
        rootContainer.addView(
            loginView,
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT
            )
        )
    }

    private fun showProductView() {
        val productView = ProductScreenView(context, fullName, email)

        rootContainer.removeAllViews()
        rootContainer.addView(
            productView,
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT
            )
        )
    }
}
