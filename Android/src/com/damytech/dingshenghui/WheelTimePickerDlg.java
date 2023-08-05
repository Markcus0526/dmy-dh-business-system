package com.damytech.dingshenghui;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Point;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.damytech.utils.ResolutionSet;
import com.damytech.utils.WheelPicker.NumericWheelAdapter;
import com.damytech.utils.WheelPicker.WheelView;

import java.util.Calendar;
import java.util.Date;

/**
 * Created by RiGSNote on 14-9-21.
 */
public class WheelTimePickerDlg extends Dialog {

    Context mContext;

    WheelView hours;
    WheelView mins;

    int defTextSize = 22;
    long mPassId = 0;
    OnDismissListener dismissListener = null;

    private int nHour = 0;
    private int nMinute = 0;

    private Date mCurDate = null;

    public WheelTimePickerDlg(Context context)
    {
        super(context);
        mContext = context;
    }

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dlg_wheel_timepicker);

        // add temp textview to get resoluted text size
        TextView temp = new TextView(mContext);
        temp.setTextSize(defTextSize);
        temp.setVisibility(View.GONE);

        RelativeLayout pL = (RelativeLayout) findViewById(R.id.parent_layout);
        pL.addView(temp);

        ResolutionSet._instance.iterateChild(((RelativeLayout)findViewById(R.id.parent_layout)).getChildAt(0));

        // get resoluted text size
        defTextSize = (int)temp.getTextSize();

        initControl();
    }

    public void setCurDate(Date date)
    {
        mCurDate = date;
    }

    private void initControl()
    {
        Button btnSave = (Button) findViewById(R.id.btnSave);
        btnSave.setOnClickListener(onClickListener);
        Button btnCancel = (Button) findViewById(R.id.btnCancel);
        btnCancel.setOnClickListener(onClickListener);

        hours = (WheelView) findViewById(R.id.hour);
        hours.setDefTextSize(defTextSize);
        hours.setAdapter(new NumericWheelAdapter(0, 23));
        hours.setLabel(mContext.getString(R.string.shi));

        mins = (WheelView) findViewById(R.id.mins);
        mins.setDefTextSize(defTextSize);
        mins.setAdapter(new NumericWheelAdapter(0, 59, "%02d"));
        mins.setLabel(mContext.getString(R.string.fen));
        mins.setCyclic(true);

        // set current date
        if (mCurDate != null)
        {
            int curHour = mCurDate.getHours();
            hours.setCurrentItem(curHour);
            int curMins = mCurDate.getMinutes();
            mins.setCurrentItem(curMins);
        }
        else
        {
            Calendar cal = Calendar.getInstance();
            int curHour = cal.get(Calendar.HOUR);
            hours.setCurrentItem(curHour);
            int curMins = cal.get(Calendar.MINUTE);
            mins.setCurrentItem(curMins);
        }
    }

    public void setOnDismissListener(OnDismissListener listener)
    {
        dismissListener = listener;
    }

    public long getPassId()
    {
        return mPassId;
    }

    public void setPassId(long passid)
    {
        mPassId = passid;
    }

    public int getHour() { return nHour; }
    public int getMinute() { return nMinute; }

    View.OnClickListener onClickListener = new View.OnClickListener()
    {
        @Override
        public void onClick(View v)
        {
            if (v.getId() == R.id.btnSave)
            {
                nHour = hours.getCurrentItem();
                nMinute = mins.getCurrentItem();

                dismissListener.onDismiss(WheelTimePickerDlg.this);
                dismiss();

            }
            else if (v.getId() == R.id.btnCancel)
            {
                dismiss();
            }

        }
    };
}
