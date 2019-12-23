package com.iron.asr_plugin;

import android.content.Context;
import android.util.Log;

import com.baidu.speech.EventManager;
import com.baidu.speech.EventManagerFactory;
import com.baidu.speech.asr.SpeechConstant;

import org.json.JSONObject;

import java.util.Map;
/**
 * User: IronRen
 * Time: 2019-09-04 11:07
 * Desc:百度语音SDK 内部类修改后，主要是调用百度SDK里的开始录音，停止录音和取消录音，释放资源功能
 */

/**
 * 初始化
 *
 * @param context
 * @param asrListener 将EventListener结果做解析的DEMO回调。使用RecogEventAdapter 适配EventListener
 */
public class AsrManager {
    private static final String TAG = "AsrManager";
    /**
     * SDK 内部核心 EventManager 类
     */
    private EventManager asr;

    // SDK 内部核心 事件回调类， 用于开发者写自己的识别回调逻辑
    private RecogEventAdapter eventListener;

    // 未release前，只能new一个
    private static volatile boolean isInited = false;

    /**
     * 初始化 提供 EventManagerFactory需要的Context和RecogEventAdapter
     *
     * @param context
     * @param listener 识别状态和结果回调
     */
    public AsrManager(Context context, OnAsrListener listener) {
        if (isInited) {
            Log.e(TAG, "还未调用release()，请勿新建一个新类");
            throw new RuntimeException("还未调用release()，请勿新建一个新类");
        }
        isInited = true;
        // SDK集成步骤 初始化asr的EventManager示例，多次得到的类，只能选一个使用
        asr = EventManagerFactory.create(context, "asr");
        // SDK集成步骤 设置回调event， 识别引擎会回调这个类告知重要状态和识别结果
        asr.registerListener(eventListener = new RecogEventAdapter(listener));
    }

    /**
     * @param params
     */
    public void start(Map<String, Object> params) {
        // SDK集成步骤 拼接识别参数
        String json = new JSONObject(params).toString();
        Log.i(TAG + ".Debug", "识别参数（反馈请带上此行日志）" + json);
        asr.send(SpeechConstant.ASR_START, json, null, 0, 0);
    }


    /**
     * 提前结束录音等待识别结果。
     */
    public void stop() {
        Log.i(TAG, "停止录音");
        // SDK 集成步骤（可选）停止录音
        if (!isInited) {
            throw new RuntimeException("release() was called");
        }
        asr.send(SpeechConstant.ASR_STOP, "{}", null, 0, 0);
    }

    /**
     * 取消本次识别，取消后将立即停止不会返回识别结果。
     * cancel 与stop的区别是 cancel在stop的基础上，完全停止整个识别流程，
     */
    public void cancel() {
        Log.i(TAG, "取消识别");
        if (!isInited) {
            throw new RuntimeException("release() was called");
        }
        // SDK集成步骤 (可选） 取消本次识别
        asr.send(SpeechConstant.ASR_CANCEL, "{}", null, 0, 0);
    }

    public void release() {
        if (asr == null) {
            return;
        }
        cancel();
        // SDK 集成步骤（可选），卸载listener
        asr.unregisterListener(eventListener);
        asr = null;
        isInited = false;
    }
}
