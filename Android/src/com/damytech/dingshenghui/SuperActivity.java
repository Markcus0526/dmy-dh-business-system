package com.damytech.dingshenghui;

import android.app.*;
import android.content.Intent;

public class SuperActivity extends Activity
{
	public ProgressDialog m_dlgProg = null;

	@Override
	protected void onResume()
    {
		super.onResume();
	}

	@Override
	protected void onPause()
    {
		super.onPause();
	}

	@Override
	protected void onNewIntent(Intent intent)
    {
		super.setIntent(intent);
	}
	public void startProgress()
	{
		startProgress(getResources().getString(R.string.qingshaodeng));
	}

	public void startProgress(String szMsg)
	{
		if (m_dlgProg != null && m_dlgProg.isShowing())
			return;

		if (m_dlgProg == null)
		{
			m_dlgProg = new ProgressDialog(SuperActivity.this);
			m_dlgProg.setMessage(szMsg);
			m_dlgProg.setCancelable(true);
		}

		m_dlgProg.show();
	}

	public void stopProgress()
	{
		if (m_dlgProg != null)
		{
			m_dlgProg.dismiss();
			m_dlgProg = null;
		}
	}
}
