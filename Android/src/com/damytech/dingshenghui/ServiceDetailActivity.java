package com.damytech.dingshenghui;

import android.content.Intent;
import android.graphics.Rect;
import android.os.Bundle;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.*;
import com.damytech.utils.ResolutionSet;
import org.w3c.dom.Text;

public class ServiceDetailActivity extends SuperActivity {
    RelativeLayout mainLayout;
    boolean bInitialized = false;
    final int MODE_BANK = 0;
    final int MODE_CREDIT = 1;
    final int MODE_INSURANCE = 2;
    final int MODE_PROPERTY = 3;
    final int MODE_SMALLMONEY = 4;
    int nMode = MODE_BANK;
    boolean bLicense = false;
    String strTitle = "";
    String strContent = "";
    long nUID = 0;

    ImageView imgBack;
    ImageView imgLicense;
    Button btnOk;
    TextView lblTitle;
    TextView lblContent;

    View.OnClickListener onClickListener = new View.OnClickListener()
    {
        @Override
        public void onClick(View v)
        {
            switch (v.getId())
            {
                case R.id.imgBack:
                    finish();
                    break;
                case R.id.btnOk:
                    if (bLicense == false)
                        return;
                    switch (nMode)
                    {
                        case MODE_BANK:
                        case MODE_CREDIT:
                        case MODE_INSURANCE:
                        case MODE_PROPERTY:
                            Intent intent = new Intent(ServiceDetailActivity.this, ServiceUploadActivity.class);
                            intent.putExtra("MODE", nMode);
                            intent.putExtra("UID", nUID);
                            startActivity(intent);
                            break;
                        case MODE_SMALLMONEY:
                            Intent intentSmall = new Intent(ServiceDetailActivity.this, SmallMoneyUploadActivity.class);
                            intentSmall.putExtra("MODE", nMode);
                            intentSmall.putExtra("UID", nUID);
                            startActivity(intentSmall);
                            break;
                    }
                    break;
                case R.id.imgLicense:
                    if (bLicense == false)
                    {
                        bLicense = true;
                        btnOk.setEnabled(true);
                        imgLicense.setImageResource(R.drawable.checked);
                        btnOk.setBackgroundDrawable(getResources().getDrawable(R.drawable.roundblueblue));
                    }
                    else
                    {
                        bLicense = false;
                        btnOk.setEnabled(false);
                        imgLicense.setImageResource(R.drawable.unchecked);
                        btnOk.setBackgroundDrawable(getResources().getDrawable(R.drawable.roundblueblue_disable));
                    }
                    break;
            }
        }
    };

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_servicedetail);

        mainLayout = (RelativeLayout)findViewById(R.id.parent_layout);
        mainLayout.getViewTreeObserver().addOnGlobalLayoutListener(
                new ViewTreeObserver.OnGlobalLayoutListener() {
                    public void onGlobalLayout() {
                        if (bInitialized == false)
                        {
                            Rect r = new Rect();
                            mainLayout.getLocalVisibleRect(r);
                            ResolutionSet._instance.setResolution(r.width(), r.height());
                            ResolutionSet._instance.iterateChild(findViewById(R.id.parent_layout));
                            bInitialized = true;
                        }
                    }
                }
        );

        initControl();

        nMode = getIntent().getIntExtra("MODE", MODE_BANK);
        nUID = getIntent().getLongExtra("UID", 0);
        strTitle = getIntent().getStringExtra("TITLE");
        strContent = getIntent().getStringExtra("CONTENT");

        lblTitle.setText(strTitle);
        lblContent.setText(strContent);
    }

    private void initControl()
    {
        imgBack = (ImageView) findViewById(R.id.imgBack);
        imgBack.setOnClickListener(onClickListener);
        imgLicense = (ImageView) findViewById(R.id.imgLicense);
        imgLicense.setOnClickListener(onClickListener);

        lblTitle = (TextView) findViewById(R.id.lblTitle);
        lblContent = (TextView) findViewById(R.id.lblContent);

        btnOk = (Button) findViewById(R.id.btnOk);
        btnOk.setOnClickListener(onClickListener);

        return;
    }
}
