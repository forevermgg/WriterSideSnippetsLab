class CustomView(context: Context, attrs: AttributeSet? = null) : ConstraintLayout(context, attrs) {
    val binding = ViewCustomBinding.inflate(LayoutInflater.from(context), this, true).apply{
        lifecycleOwner = context as? LifecycleOwner
    }
}