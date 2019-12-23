package com.iron.location_plugin;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.util.Log;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.baidu.location.BDAbstractLocationListener;
import com.baidu.location.BDLocation;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * User: IronRen
 * Time: 2019-12-10 11:09
 * Desc:
 */
public class LocationPlugin implements MethodChannel.MethodCallHandler {
    private final Activity activity;
    private LocationClient locationClient;
    private BDAbstractLocationListener locationListener;

    public static void registerWith(PluginRegistry.Registrar registrar) {
        MethodChannel channel = new MethodChannel(registrar.messenger(), "location_plugin");
        LocationPlugin instance = new LocationPlugin(registrar);
        channel.setMethodCallHandler(instance);
    }

    private LocationPlugin(PluginRegistry.Registrar registrar) {
        this.activity = registrar.activity();
    }

    @Override
    public void onMethodCall(@NotNull MethodCall methodCall, @NotNull MethodChannel.Result result) {
        if (methodCall.method.equals("setAk")){
            result.success(true);
        }else if (methodCall.method.equals("getLocation")){
            initPermission();
            initLocation(new CurrentLocationListener(result));
        }else {
            result.notImplemented();
        }

    }

    /**
     * 初始化定位
     * @param locationListener
     */
    private void initLocation(BDAbstractLocationListener locationListener) {
        if (locationClient == null){
            locationClient = new LocationClient(activity.getApplicationContext());
            //注册监听
            locationClient.registerLocationListener(locationListener);
        }
        this.locationListener = locationListener;
        LocationClientOption locationClientOption = defaultLocationClientOption();
        locationClient.setLocOption(locationClientOption);
        locationClient.start();
    }

    /**
     * 关闭定位
     */
    private void closeLocation(){
        if (locationClient != null){
            if (locationListener != null){
                locationClient.unRegisterLocationListener(locationListener);
            }
            locationClient.stop();
            locationClient = null;
        }
    }

    /**
     * android 6.0 以上需要动态申请权限
     */
    private void initPermission() {
        String[] permissions = {Manifest.permission.ACCESS_COARSE_LOCATION,
                Manifest.permission.ACCESS_FINE_LOCATION
        };

        ArrayList<String> toApplyList = new ArrayList<>();

        for (String perm : permissions) {
            if (PackageManager.PERMISSION_GRANTED != ContextCompat.checkSelfPermission(activity, perm)) {
                toApplyList.add(perm);
                //进入到这里代表没有权限.
            }
        }
        String[] tmpList = new String[toApplyList.size()];
        if (!toApplyList.isEmpty()) {
            ActivityCompat.requestPermissions(activity, toApplyList.toArray(tmpList), 123);
        }
    }


    /**
     * 设置定位的相关参数
     * @return
     */
    private LocationClientOption defaultLocationClientOption(){
        LocationClientOption option = new LocationClientOption();

        //可选，设置定位模式，默认高精度
        //LocationMode.Hight_Accuracy：高精度；
        //LocationMode. Battery_Saving：低功耗；
        //LocationMode. Device_Sensors：仅使用设备；
        option.setLocationMode(LocationClientOption.LocationMode.Hight_Accuracy);

        //可选，设置返回经纬度坐标类型，默认GCJ02
        //GCJ02：国测局坐标；
        //BD09ll：百度经纬度坐标；
        //BD09：百度墨卡托坐标；
        //海外地区定位，无需设置坐标类型，统一返回WGS84类型坐标
        option.setCoorType("bd09ll");

        //可选，设置发起定位请求的间隔，int类型，单位ms
        //如果设置为0，则代表单次定位，即仅定位一次，默认为0
        //如果设置非0，需设置1000ms以上才有效
        option.setScanSpan(1000);

        //可选，是否需要地址信息，默认为不需要，即参数为false
        //如果开发者需要获得当前点的地址信息，此处必须为true
        option.setIsNeedAddress(true);

        //可选，设置是否使用gps，默认false
        //使用高精度和仅用设备两种定位模式的，参数必须设置为true
        option.setOpenGps(true);

        //可选，设置是否需要设备方向结果
        option.setNeedDeviceDirect(false);

        //可选，设置是否当GPS有效时按照1S/1次频率输出GPS结果，默认false
        option.setLocationNotify(true);

        //可选，定位SDK内部是一个service，并放到了独立进程。
        //设置是否在stop的时候杀死这个进程，默认（建议）不杀死，即setIgnoreKillProcess(true)
        option.setIgnoreKillProcess(true);

        //可选，设置是否收集Crash信息，默认收集，即参数为false
        option.SetIgnoreCacheException(false);

        //可选，是否需要位置描述信息，默认为不需要，即参数为false
        //如果开发者需要获得当前点的位置信息，此处必须为true
        option.setIsNeedLocationDescribe(true);

        //可选，是否需要周边POI信息，默认为不需要，即参数为false
        //如果开发者需要获得周边POI信息，此处必须为true
        option.setIsNeedLocationPoiList(false);

        //可选，V7.2版本新增能力
        //如果设置了该接口，首次启动定位时，会先判断当前Wi-Fi是否超出有效期，若超出有效期，会先重新扫描Wi-Fi，然后定位
        option.setWifiCacheTimeOut(5*60*1000);

        //可选，设置是否需要过滤GPS仿真结果，默认需要，即参数为false
        option.setEnableSimulateGps(false);

        return option;
    }


    /**
     * 将地址转换成Map对象
     * @param location
     * @return
     */
    private Map<String,Object> location2Map(BDLocation location){
        Map<String,Object> json = new HashMap<>();
        json.put("latitude",location.getLatitude());    //获取纬度信息
        json.put("longitude",location.getLongitude());    //获取经度信息

        json.put("country",location.getCountry());    //获取国家
        json.put("countryCode", location.getCountryCode());
        json.put("province",location.getProvince());    //获取省份
        json.put("city",location.getCity());    //获取城市
        json.put("cityCode", location.getCityCode());
        json.put("district",location.getDistrict());    //获取区县
        json.put("street",location.getStreet());    //获取街道信息
        json.put("streetNumber",location.getStreetNumber());    //获取街道号信息

        json.put("locationDescribe",location.getLocationDescribe());    //获取位置描述信息
        json.put("adCode",location.getAdCode());    //获取城市adcode

        json.put("isInChina",location.getLocationWhere() == BDLocation.LOCATION_WHERE_IN_CN);

        //获取定位类型、定位错误返回码，具体信息可参照类参考中BDLocation类中的说明
        json.put("errorCode",location.getLocType());
        return json;
    }


    class  CurrentLocationListener extends BDAbstractLocationListener {
        MethodChannel.Result result;

        CurrentLocationListener(MethodChannel.Result result) {
            this.result = result;
        }

        @Override
        public void onReceiveLocation(BDLocation bdLocation) {
            if (bdLocation != null){
                Log.d("BDLocation","==="+bdLocation.getAdCode());
                if (result != null){
                    try {
                        result.success(location2Map(bdLocation));
                    } finally {
                        closeLocation();
                    }
                }
            }
        }
    }
}
