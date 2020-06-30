package com.sandy.guoguo.babylib.dialogs.local_address;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.app.AlertDialog;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import com.google.gson.Gson;
import com.sandy.guoguo.babylib.R;
import com.sandy.guoguo.babylib.utils.GetJsonDataUtil;
import com.sandy.guoguo.babylib.utils.Utility;
import com.sandy.guoguo.babylib.widgets.wheel.AbstractWheelTextAdapter;
import com.sandy.guoguo.babylib.widgets.wheel.WheelView;
import com.sandy.guoguo.babylib.widgets.wheel.listens.OnWheelChangedListener;
import com.sandy.guoguo.babylib.widgets.wheel.listens.OnWheelScrollListener;

import org.json.JSONArray;

import java.util.ArrayList;
import java.util.List;

public class LocalAddressDialog extends AlertDialog implements View.OnClickListener {


    private Context context;

    private WheelView viewProvince;
    private WheelView viewCity;
    private WheelView viewDistrict;

    private ArrayList<JsonBean> options1Items = new ArrayList<>(); //省
    private ArrayList<ArrayList<String>> options2Items = new ArrayList<>();//市
    private ArrayList<ArrayList<ArrayList<String>>> options3Items = new ArrayList<>();//区

    private int provinceIndex, cityIndex, districtIndex;

    private ClickListener listener;

    public LocalAddressDialog(@NonNull Context context, ClickListener listener) {
        super(context, R.style.dialog);
        this.context = context;
        this.listener = listener;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Window window = this.getWindow();
        window.setGravity(Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL);
        window.getDecorView().setPadding(20, 0, 20, 0);
        window.setLayout(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.WRAP_CONTENT);

        setContentView(R.layout.dialog_local_address);
        initViewAndControl();

        initJsonData();

        setUpData();
    }

    private void setUpData() {
        AddressWheelAdapter provinceAdapter = new AddressWheelAdapter(context, options1Items);
        provinceAdapter.setItemResource(R.layout.wheel_text_item);
        viewProvince.setViewAdapter(provinceAdapter);
        viewProvince.setCyclic(false);
        viewProvince.setCurrentItem(0);

        provinceIndex = 0;

        setCityData2UI();
    }

    private void setCityData2UI() {
        CityWheelAdapter cityAdapter = new CityWheelAdapter(context, options2Items.get(provinceIndex));
        cityAdapter.setItemResource(R.layout.wheel_text_item);//设置圈里面View的视图
        viewCity.setViewAdapter(cityAdapter);

        cityIndex = 0;

        viewCity.setCyclic(false);
        viewCity.setCurrentItem(0);

        setDistrictData2UI();
    }

    private void setDistrictData2UI() {
        CityWheelAdapter cityAdapter = new CityWheelAdapter(context, options3Items.get(provinceIndex).get(cityIndex));
        cityAdapter.setItemResource(R.layout.wheel_text_item);//设置圈里面View的视图
        viewDistrict.setViewAdapter(cityAdapter);

        viewDistrict.setCyclic(false);
        viewDistrict.setCurrentItem(0);
    }

    private class AddressWheelAdapter extends AbstractWheelTextAdapter {

        // items
        private List<JsonBean> addressItems;


        public AddressWheelAdapter(Context context, List<JsonBean> addressItems) {
            super(context);

            this.addressItems = addressItems;
        }

        @Override
        public CharSequence getItemText(int index) {
            int len = getItemsCount();
            String name = "";
            if (index >= 0 && index < len) {
                name = addressItems.get(index).getName();
            }
            return name;
        }

        @Override
        public int getItemsCount() {
            return addressItems == null ? 0 : addressItems.size();
        }
    }

    private class CityWheelAdapter extends AbstractWheelTextAdapter {

        // items
        private List<String> addressItems;


        public CityWheelAdapter(Context context, List<String> addressItems) {
            super(context);

            this.addressItems = addressItems;
        }

        @Override
        public CharSequence getItemText(int index) {
            int len = getItemsCount();
            String name = "";
            if (index >= 0 && index < len) {
                name = addressItems.get(index);
            }
            return name;
        }

        @Override
        public int getItemsCount() {
            return addressItems == null ? 0 : addressItems.size();
        }
    }

    private void initViewAndControl() {
        findViewById(R.id.tvComplete).setOnClickListener(this);
        findViewById(R.id.tvCancel).setOnClickListener(this);

        viewProvince = findViewById(R.id.wheelViewProvince);
        viewCity = findViewById(R.id.wheelViewCity);
        viewDistrict = findViewById(R.id.wheelViewDistrict);

        DisplayMetrics dm = Utility.getDisplayScreenSize((Activity) context);
        viewProvince.setHeight(dm.heightPixels / 3);
        viewCity.setHeight(dm.heightPixels / 3);
        viewDistrict.setHeight(dm.heightPixels / 3);

        initWheel();
    }

    private void initWheel() {

        viewProvince.addChangingListener(changedListener);
        viewCity.addChangingListener(changedListener);
        viewDistrict.addChangingListener(changedListener);

        viewProvince.addScrollingListener(scrollListener);
        viewCity.addScrollingListener(scrollListener);
        viewDistrict.addScrollingListener(scrollListener);

    }

    private OnWheelScrollListener scrollListener = new OnWheelScrollListener() {
        @Override
        public void onScrollingStarted(WheelView wheel) {

        }

        @Override
        public void onScrollingFinished(WheelView wheel) {
            int id = wheel.getId();
            if (id == R.id.wheelViewProvince) {
                provinceIndex = wheel.getCurrentItem();
                setCityData2UI();
            } else if (id == R.id.wheelViewCity) {
                cityIndex = wheel.getCurrentItem();
                setDistrictData2UI();
            } else if (id == R.id.wheelViewDistrict) {
                districtIndex = wheel.getCurrentItem();
            }

        }
    };


    private OnWheelChangedListener changedListener = new OnWheelChangedListener() {
        @Override
        public void onChanged(WheelView wheel, int oldValue, int newValue) {
            wheel.invalidateWheel(true);
        }
    };

    private void initJsonData() {//解析数据 （省市区三级联动）
        /**
         * 注意：assets 目录下的Json文件仅供参考，实际使用可自行替换文件
         * 关键逻辑在于循环体
         *
         * */
        String JsonData = new GetJsonDataUtil().getJson(context, "province.json");//获取assets目录下的json文件数据

        ArrayList<JsonBean> jsonBean = parseData(JsonData);//用Gson 转成实体

        /**
         * 添加省份数据
         *
         * 注意：如果是添加的JavaBean实体，则实体类需要实现 IPickerViewData 接口，
         * PickerView会通过getPickerViewText方法获取字符串显示出来。
         */
        options1Items = jsonBean;

        for (int i = 0; i < jsonBean.size(); i++) {//遍历省份
            ArrayList<String> CityList = new ArrayList<>();//该省的城市列表（第二级）
            ArrayList<ArrayList<String>> Province_AreaList = new ArrayList<>();//该省的所有地区列表（第三级）

            for (int c = 0; c < jsonBean.get(i).getCityList().size(); c++) {//遍历该省份的所有城市
                String CityName = jsonBean.get(i).getCityList().get(c).getName();
                CityList.add(CityName);//添加城市
                ArrayList<String> City_AreaList = new ArrayList<>();//该城市的所有地区列表

                //如果无地区数据，建议添加空字符串，防止数据为null 导致三个选项长度不匹配造成崩溃
                if (jsonBean.get(i).getCityList().get(c).getArea() == null
                        || jsonBean.get(i).getCityList().get(c).getArea().size() == 0) {
                    City_AreaList.add("");
                } else {
                    City_AreaList.addAll(jsonBean.get(i).getCityList().get(c).getArea());
                }
                Province_AreaList.add(City_AreaList);//添加该省所有地区数据
            }

            /**
             * 添加城市数据
             */
            options2Items.add(CityList);

            /**
             * 添加地区数据
             */
            options3Items.add(Province_AreaList);
        }
    }

    public ArrayList<JsonBean> parseData(String result) {//Gson 解析
        ArrayList<JsonBean> detail = new ArrayList<>();
        try {
            JSONArray data = new JSONArray(result);
            Gson gson = new Gson();
            for (int i = 0; i < data.length(); i++) {
                JsonBean entity = gson.fromJson(data.optJSONObject(i).toString(), JsonBean.class);
                detail.add(entity);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return detail;
    }


    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.tvComplete) {
            String province = options1Items.get(provinceIndex).getName();
            String city = options2Items.get(provinceIndex).get(cityIndex);
            String district = options3Items.get(provinceIndex).get(cityIndex).get(districtIndex);
            listener.clickConfirm(province == null ? "" : province
                    , city == null ? "" : city
                    , district == null ? "" : district
            );
        }
        dismiss();
    }


    public interface ClickListener {
        void clickConfirm(String province, String city, String district);
    }
}
