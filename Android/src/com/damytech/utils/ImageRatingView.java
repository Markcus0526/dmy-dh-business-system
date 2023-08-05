package com.damytech.utils;

import android.content.Context;
import android.graphics.*;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

public class ImageRatingView extends View {
	private final int IMAGE_MAXHEIGHT_RATE = 80;
	private final String log_tag = "Logger(ImageRatingView)";

	private Context parentCtx = null;

	private int nMaxValue = 5;						  // Maximum available rate value
	private double fRatingValue = 0;					// Current rating value
	private Bitmap bmpEmpty = null, bmpFill = null;	 // Images for the fill state and the empty state
	private double fStep = 0.5f;						// Step size(Can be float)
	private int nBorderMarginRate = 20;				 // The interval between image and the left, right border
	private int nInternalMarginRate = 20;			   // The interval between image and image
	private boolean isEditable = true;				  // Editable flag. Default value is true. If false, can't edit.

	private ImageRatingListener rating_listener = null;


	// Internal parameters
	private double oldValue = 0;

	private int borderMargin = -1, internalMargin = -1, topMargin = -1;
	private int orgImageWidth = 0, imageWidth = 0, imageHeight = 0;


	public ImageRatingView(Context context) {
		super(context);
		parentCtx = context;
	}

	public ImageRatingView(Context context, AttributeSet attrs) {
		super(context, attrs);
		parentCtx = context;
	}

	public ImageRatingView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		parentCtx = context;
	}


	@Override
	protected void onDraw(Canvas canvas) {
		super.onDraw(canvas);

		if (bmpFill == null) {
			Log.d(log_tag, "Image for fill state is not set. Cannot draw star rating view");
			return;
		}

		calcSizes();

		// Draw fill images
		int nRateValue = (int)fRatingValue;
		for (int i = 1; i <= nRateValue; i++)
		{
			canvas.drawBitmap(bmpFill, new Rect(0, 0, bmpFill.getWidth(), bmpFill.getHeight()), calcImageRect(i), null);
		}

		// Draw empty images
		for (int i = nRateValue + 1; i <= nMaxValue; i++)
		{
			if (bmpEmpty != null)
				canvas.drawBitmap(bmpEmpty, new Rect(0, 0, bmpEmpty.getWidth(), bmpEmpty.getHeight()), calcImageRect(i), null);
		}

		// Draw overlap part
		double fRemVal = fRatingValue - nRateValue;
		if (fRemVal != 0)
		{
			RectF rcImage = calcImageRect(nRateValue + 1);
			RectF rcFill = new RectF(rcImage.left, rcImage.top, rcImage.left + rcImage.width() * (float)fRemVal, rcImage.bottom);

			int nSaveCount = canvas.save();
			canvas.clipRect(rcFill);
			canvas.drawBitmap(bmpFill, new Rect(0, 0, bmpFill.getWidth(), bmpFill.getHeight()), rcImage, null);
			canvas.restoreToCount(nSaveCount);
		}
	}

	/*
	 * Method to get the image rect from the image index. The first image index is considered as 1
	 */
	private RectF calcImageRect(int index)
	{
		RectF rcImage = new RectF(borderMargin + ((index - 1) * (imageWidth + internalMargin)),
				topMargin,
				borderMargin + ((index - 1) * (imageWidth + internalMargin)) + imageWidth,
				topMargin + imageHeight);
		return rcImage;
	}


	public void maxValue(int nMaxValue)
	{
		this.nMaxValue = nMaxValue;
	}

	public int maxValue()
	{
		return this.nMaxValue;
	}

	public void defaultValue(double fDefValue)
	{
		this.fRatingValue = fDefValue;
	}

	public double defaultValue()
	{
		return this.fRatingValue;
	}

	public void emptyImage(Bitmap bmpEmpty)
	{
		this.bmpEmpty = bmpEmpty;
	}

	public void emptyImage(int nResID)
	{
		try {
			this.bmpEmpty = BitmapFactory.decodeResource(getResources(), nResID);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public Bitmap emptyImage()
	{
		return this.bmpEmpty;
	}

	public void fillImage(Bitmap bmpFill)
	{
		this.bmpFill = bmpFill;
	}

	public void fillImage(int nResID)
	{
		try {
			this.bmpFill = BitmapFactory.decodeResource(getResources(), nResID);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public Bitmap fillImage()
	{
		return this.bmpFill;
	}

	public void step(double fStep)
	{
		this.fStep = fStep;
	}

	public double step()
	{
		return this.fStep;
	}

	public void borderMarginRate(int nBorderMarginRate)
	{
		this.nBorderMarginRate = nBorderMarginRate;
	}

	public int borderMarginRate()
	{
		return this.nBorderMarginRate;
	}

	public void internalMarginRate(int nInternalMarginRate)
	{
		this.nInternalMarginRate = nInternalMarginRate;
	}

	public int internalMarginRate()
	{
		return this.nInternalMarginRate;
	}

	public void editable(boolean isEditable)
	{
		this.isEditable = isEditable;
	}

	public boolean editable()
	{
		return this.isEditable;
	}

	public void ratingListener(ImageRatingListener listener)
	{
		this.rating_listener = listener;
	}

	public ImageRatingListener ratingListener()
	{
		return this.rating_listener;
	}


	private double calcRateValue(int nXPos)
	{
		if (nXPos < 0) {
			fRatingValue = 0;
		} else if (nXPos > getWidth()) {
			fRatingValue = nMaxValue;
		} else if (nMaxValue <= 1) {
			fRatingValue = nMaxValue;
		} else {
			// Get current rating value
			int nIndex = -1, nOffset = 0;;
			for (int i = 0; i < nMaxValue; i++) {
				int nCurStarLeftBnd = borderMargin + (imageWidth + internalMargin) * i;
				int nCurStarRightBnd = 0;
				if (i == nMaxValue - 1)
					nCurStarRightBnd = getWidth() + 1;
				else
					nCurStarRightBnd = nCurStarLeftBnd + imageWidth + internalMargin;

				if (nCurStarLeftBnd <= nXPos && nCurStarRightBnd > nXPos) {
					nOffset = nXPos - nCurStarLeftBnd;
					nIndex = i;
					break;
				}
			}

			if (nIndex < 0) {
				fRatingValue = 0;
			} else {
				if (nOffset > imageWidth)
					nOffset = imageWidth;

				double fValue = nIndex + (double)nOffset / imageWidth;
				if (fValue >= nMaxValue) {
					fRatingValue = nMaxValue;
				} else {
					int nStepCount = (int) (fValue / fStep);
					double fRemVal = fValue - nStepCount * fStep;
					double fCompleteValue = nStepCount * fStep;

					if (fRemVal == 0)
						fRatingValue = fCompleteValue;
					else if (fRemVal < fStep)
						fRatingValue = fCompleteValue;
					else
						fRatingValue = fCompleteValue + fStep;
				}
			}
		}

		return fRatingValue;
	}


	private void callRateFeedback()
	{
		if (rating_listener != null)
			rating_listener.ratingChanged(fRatingValue);
	}

    public double getCurVal()
    {
        return fRatingValue;
    }

	// Calculate image size and margins
	private void calcSizes()
	{
		// The image width formula is as follows:
		// getWidth() = imageWidth * nMaxValue + (imageWidth * nInternalMarginRate / 100) * (nMaxValue - 1) + (imageWidth * nBorderMarginRate / 100) * 2
		// -> imageWidth = getWidth() / (nMaxValue + nInternalMarginRate * (nMaxValue - 1) / 100 + nBorderMarginRate * 2 / 100)
		orgImageWidth = (int) (getWidth() / (nMaxValue + (double) nInternalMarginRate * (nMaxValue - 1) / 100 + (double) nBorderMarginRate * 2 / 100));
		imageHeight = getHeight() * IMAGE_MAXHEIGHT_RATE / 100;

		// Normalize image size
		if (imageHeight < orgImageWidth) {
			imageWidth = imageHeight;
			borderMargin = internalMargin = (getWidth() - imageWidth * nMaxValue) / (nMaxValue + 1);
		} else {
			imageHeight = orgImageWidth;
			imageWidth = orgImageWidth;

			borderMargin = imageWidth * nBorderMarginRate / 100;
			internalMargin = imageWidth * nInternalMarginRate / 100;
		}

		topMargin = (getHeight() - imageHeight) / 2;
	}


	@Override
	public boolean onTouchEvent(MotionEvent event) {
		if (internalMargin < 0)
		{
			calcSizes();
		}

		if (isEditable) {
			switch (event.getAction()) {
				case MotionEvent.ACTION_CANCEL:
				case MotionEvent.ACTION_HOVER_EXIT:
					fRatingValue = oldValue;
					invalidate();
					callRateFeedback();
					ImageRatingView.this.getParent().requestDisallowInterceptTouchEvent(false);
					break;
				case MotionEvent.ACTION_UP:
					ImageRatingView.this.getParent().requestDisallowInterceptTouchEvent(false);
				case MotionEvent.ACTION_MOVE:
					calcRateValue((int) event.getX());
					invalidate();
					callRateFeedback();
					break;
				case MotionEvent.ACTION_DOWN:
					ImageRatingView.this.getParent().requestDisallowInterceptTouchEvent(true);
					calcRateValue((int) event.getX());
					invalidate();
					callRateFeedback();
					break;
				default:
					break;
			}
		}

		return true;
	}


	public class ImageRatingViewBuilder {
		private Context parentCtx = null;

		// Basic public parameters
		private int nMaxValue = 5;						  // Maximum available rate value
		private double fRatingValue = 0;					// Current rating value
		private Bitmap bmpEmpty = null, bmpFill = null;	 // Images for the fill state and the empty state
		private double fStep = 0.5f;						// Step size(Can be double)
		private int nBorderMarginRate = 20;				 // The interval between image and the left, right border
		private int nInternalMarginRate = 20;			   // The interval between image and image
		private boolean isEditable = true;				  // Editable flag. Default value is true. If false, can't edit.

		private ImageRatingListener rating_listener = null;


		public ImageRatingViewBuilder(Context parentCtx)
		{
			this.parentCtx = parentCtx;
		}

		public ImageRatingViewBuilder maxValue(int nMaxValue)
		{
			this.nMaxValue = nMaxValue;
			return this;
		}

		public ImageRatingViewBuilder defaultValue(double fDefValue)
		{
			this.fRatingValue = fDefValue;
			return this;
		}

		public ImageRatingViewBuilder emptyImage(Bitmap bmpEmpty)
		{
			this.bmpEmpty = bmpEmpty;
			return this;
		}

		public ImageRatingViewBuilder emptyImage(int nResID)
		{
			try {
				this.bmpEmpty = BitmapFactory.decodeResource(getResources(), nResID);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
			return this;
		}

		public ImageRatingViewBuilder fillImage(Bitmap bmpFill)
		{
			this.bmpFill = bmpFill;
			return this;
		}

		public ImageRatingViewBuilder fillImage(int nResID)
		{
			try {
				this.bmpFill = BitmapFactory.decodeResource(getResources(), nResID);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
			return this;
		}

		public ImageRatingViewBuilder step(double fStep)
		{
			this.fStep = fStep;
			return this;
		}

		public ImageRatingViewBuilder borderMarginRate(int nBorderMarginRate)
		{
			this.nBorderMarginRate = nBorderMarginRate;
			return this;
		}

		public ImageRatingViewBuilder internalMarginRate(int nInternalMarginRate)
		{
			this.nInternalMarginRate = nInternalMarginRate;
			return this;
		}

		public ImageRatingViewBuilder editable(boolean isEditable)
		{
			this.isEditable = isEditable;
			return this;
		}

		public ImageRatingViewBuilder ratingListener(ImageRatingListener listener)
		{
			this.rating_listener = listener;
			return this;
		}


		public ImageRatingView build()
		{
			if (parentCtx == null)
				return null;

			ImageRatingView ratingView = new ImageRatingView(parentCtx);

			ratingView.maxValue(nMaxValue);
			ratingView.defaultValue(fRatingValue);
			ratingView.emptyImage(bmpEmpty = null);
			ratingView.fillImage(bmpFill);
			ratingView.step(fStep);
			ratingView.borderMarginRate(nBorderMarginRate);
			ratingView.internalMarginRate(nInternalMarginRate);
			ratingView.editable(isEditable);
			ratingView.ratingListener(rating_listener);

			return ratingView;
		}
	}


	public interface ImageRatingListener
	{
		public void ratingChanged(double fRate);
	}


}
