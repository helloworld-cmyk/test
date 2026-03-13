package com.example.first_app

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.text.InputType
import android.text.method.PasswordTransformationMethod
import android.view.Gravity
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView

class LoginScreenView(
	context: Context,
	private val onLoginSuccess: (fullName: String, email: String) -> Unit
) : FrameLayout(context) {

	private val emailInput = EditText(context)
	private val passwordInput = EditText(context)
	private val errorLabel = TextView(context)

	private val validEmail = "an.nguyen@example.com"
	private val validPassword = "An@123456"
	private val successFullName = "Nguyễn Văn An"

	init {
		background = GradientDrawable(
			GradientDrawable.Orientation.TL_BR,
			intArrayOf(0xFFF5F7FF.toInt(), 0xFFFFFFFF.toInt())
		)

		val scrollView = ScrollView(context).apply {
			isFillViewport = true
			overScrollMode = OVER_SCROLL_ALWAYS
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

		contentWrapper.addView(cardLayout, cardParams)
		addView(scrollView, LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT))

		val iconLabel = TextView(context).apply {
			text = "👤"
			textSize = 48f
			gravity = Gravity.CENTER
		}

		val titleLabel = TextView(context).apply {
			text = "Welcome Back"
			textSize = 28f
			typeface = Typeface.DEFAULT_BOLD
			gravity = Gravity.CENTER_HORIZONTAL
		}

		val subtitleLabel = TextView(context).apply {
			text = "Sign in to continue"
			textSize = 15f
			setTextColor(0xFF8B8B8B.toInt())
			gravity = Gravity.CENTER_HORIZONTAL
		}

		cardLayout.addView(iconLabel, linearParams(bottomDp = 8, gravity = Gravity.CENTER_HORIZONTAL))
		cardLayout.addView(titleLabel, linearParams(bottomDp = 4, gravity = Gravity.CENTER_HORIZONTAL))
		cardLayout.addView(subtitleLabel, linearParams(bottomDp = 20, gravity = Gravity.CENTER_HORIZONTAL))

		cardLayout.addView(createInputBlock("Email", emailInput, isPassword = false))
		cardLayout.addView(createInputBlock("Password", passwordInput, isPassword = true, topDp = 14))

		val forgotLabel = TextView(context).apply {
			text = "Forgot password?"
			textSize = 14f
			setTextColor(0xFF2979FF.toInt())
			setTypeface(typeface, Typeface.BOLD)
			gravity = Gravity.END
		}
		cardLayout.addView(forgotLabel, linearParams(topDp = 12))

		val signInButton = Button(context).apply {
			text = "Sign In"
			textSize = 16f
			setTextColor(Color.WHITE)
			isAllCaps = false
			setTypeface(typeface, Typeface.BOLD)
			background = roundedDrawable(color = 0xFF2979FF.toInt(), radiusDp = 12f)
			setPadding(0, context.dp(14), 0, context.dp(14))
			setOnClickListener { submitLogin() }
		}
		cardLayout.addView(signInButton, linearParams(topDp = 16))

		errorLabel.apply {
			textSize = 13f
			setTextColor(0xFFE53935.toInt())
			visibility = View.GONE
		}
		cardLayout.addView(errorLabel, linearParams(topDp = 10))

		val signupRow = LinearLayout(context).apply {
			orientation = LinearLayout.HORIZONTAL
			gravity = Gravity.CENTER
		}

		val noAccountLabel = TextView(context).apply {
			text = "Don\u2019t have an account?"
			textSize = 14f
			setTextColor(0xFF8B8B8B.toInt())
		}

		val signupLabel = TextView(context).apply {
			text = "Sign up"
			textSize = 14f
			setTextColor(0xFF2979FF.toInt())
			setTypeface(typeface, Typeface.BOLD)
		}

		signupRow.addView(noAccountLabel)
		signupRow.addView(TextView(context).apply { text = "  " })
		signupRow.addView(signupLabel)

		cardLayout.addView(signupRow, linearParams(topDp = 18, gravity = Gravity.CENTER_HORIZONTAL, bottomDp = 8))
	}

	private fun createInputBlock(
		title: String,
		input: EditText,
		isPassword: Boolean,
		topDp: Int = 0
	): LinearLayout {
		val container = LinearLayout(context).apply {
			orientation = LinearLayout.VERTICAL
		}

		val titleLabel = TextView(context).apply {
			text = title
			textSize = 13f
			setTextColor(0xFF8B8B8B.toInt())
			setTypeface(typeface, Typeface.BOLD)
		}

		input.apply {
			textSize = 15f
			setTextColor(0xFF1E1E1E.toInt())
			setPadding(context.dp(12), context.dp(12), context.dp(12), context.dp(12))
			background = roundedDrawable(color = 0xFFF2F5FA.toInt(), radiusDp = 12f)
			hint = if (isPassword) "\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022" else "you@example.com"
			isSingleLine = true
			inputType = if (isPassword) {
				InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_VARIATION_PASSWORD
			} else {
				InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS
			}
			if (isPassword) {
				transformationMethod = PasswordTransformationMethod.getInstance()
			}
		}

		container.addView(titleLabel)
		container.addView(input, linearParams(topDp = 8))

		container.layoutParams = linearParams(topDp = topDp)
		return container
	}

	private fun submitLogin() {
		val normalizedEmail = emailInput.text.toString().trim().lowercase()
		val submittedPassword = passwordInput.text.toString()

		if (normalizedEmail != validEmail || submittedPassword != validPassword) {
			errorLabel.text = "Email hoặc mật khẩu không đúng"
			errorLabel.visibility = View.VISIBLE
			return
		}

		errorLabel.text = ""
		errorLabel.visibility = View.GONE
		onLoginSuccess(successFullName, validEmail)
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
}

private fun Context.dp(value: Int): Int {
	return (value * resources.displayMetrics.density).toInt()
}

private fun Context.dpF(value: Float): Float {
	return value * resources.displayMetrics.density
}
