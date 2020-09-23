package com.wiseq.cn.commons.utils;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.QuHelper;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 返回信息统一处理
 **/
public class ResultUtils {
    /**
     * 返回结果
     *
     * @param code    code
     * @param message 提示信息
     * @param object  传入对象 (null)
     * @return Result
     */
    public static Result setResult(Integer code, String message, Object object) {
        Result result = new Result();
        result.setCode(code);
        result.setMessage(message);
        result.setData(object);
        return result;
    }

    /**
     * 正确是返回
     *
     * @param code
     * @param message
     * @param object
     * @return
     */
    public static Result success(Integer code, String message, Object object) {
        return setResult(code, message, object);
    }
    /**
     * 正确是返回
     * @param object
     * @return
     */
    public static Result success(Object object) {
        return setResult(0, "", object);
    }

    /**
     * 正确是返回
     * @return
     */
    public static Result success() {
        return setResult(0, "", null);
    }

     /*
      * 正确提示信息
      **/

    public static Result success(ResultEnum resultEnum) {
        return setResult(0, resultEnum.getStateInfo(), resultEnum.getState());
    }

    /**
     * 错误是返回
     *
     * @param code
     * @param message
     * @return
     */
    public static Result error(Integer code, String message) {
        return setResult(code, message, null);
    }

    public static Result error(ResultEnum resultEnum) {
        return setResult(resultEnum.getState(), resultEnum.getStateInfo(), null);
    }

    public static Result error(ResultEnum resultEnum,Object object) {
        return setResult(resultEnum.getState(), resultEnum.getStateInfo(), object);
    }

    /**
     * json统一处理
     *
     * @param sucessCode
     * @param errorCode
     * @param message
     * @param object
     * @return
     */

    public static Result loadResult(Integer sucessCode, Integer errorCode, String message, Object object) {
        if (QuHelper.isNumeric(sucessCode)) {
            return success(sucessCode, message, object);
        }

        if (QuHelper.isNumeric(errorCode)) {
            return error(errorCode, message);
        }
        return error(-1, message);
    }

    /***
     * 返回结果
     *
     * @param object        传入的对象
     * @param bindingResult 注解错误绑定对象
     * @return Result
     */
    public static Result loadResult(Object object, BindingResult bindingResult) {
        if (bindingResult != null && bindingResult.hasErrors()) {
            StringBuilder sb = new StringBuilder();

            List<FieldError> allErrors = bindingResult.getFieldErrors();
            for (int i = 0; i < allErrors.size(); i++) {
                if (i == 0) {
                    if (allErrors.get(i).getCode().toLowerCase().equals("typeMismatch".toLowerCase())) {
                        sb.append(ResultEnum.UNNORMAL_INPUT_ERROR.getState() + ":" + ResultEnum.UNNORMAL_INPUT_ERROR.getStateInfo());
                    } else {
                        sb.append(allErrors.get(i).getDefaultMessage());
                    }
                } else {
                    if (allErrors.get(i).getCode().toLowerCase().equals("typeMismatch".toLowerCase())) {
                        sb.append(" || " + ResultEnum.UNNORMAL_INPUT_ERROR.getState() + ":" + ResultEnum.UNNORMAL_INPUT_ERROR.getStateInfo());
                    } else {
                        sb.append(" || " + allErrors.get(i).getDefaultMessage());
                    }
                }
            }
            Result result = error(ResultEnum.UNNORMAL_INPUT_ERROR.getState(), sb.toString());
            return result;
        }

        Result result = success(object);
        return result;
    }
}
