package com.wiseq.cn.ykAi.service.serviceimpl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.MaterialTypeMap;
import com.wiseq.cn.entity.ykAi.MaterialTypeMapForPage;
import com.wiseq.cn.entity.ykAi.MaterialTypeMapMix;
import com.wiseq.cn.ykAi.dao.MaterialTypeMapMapper;
import com.wiseq.cn.ykAi.service.MaterialTypeMapService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:  原材料类型编码
 * 芯片：0 ，荧光粉：1 ，胶水：2 ，
 * 支架：3 ，沉淀分：4 ，扩散粉：5
 */
@Service
@Transactional
public class MaterialTypeMapServiceImpl implements MaterialTypeMapService {

    @Autowired
    MaterialTypeMapMapper materialTypeMapMapper;

    /**
     * 原材料新增(编码内容校验+重复性校验)
     *
     * @param materialTypeMapList
     * @return
     */
    @Override
    public Result insert(List<MaterialTypeMap> materialTypeMapList) {
        if (materialTypeMapList.size() > 0) {
            for (MaterialTypeMap materialTypeMap : materialTypeMapList) {
//                RegexMatches(materialTypeMap.getMapRule());
//                if (false) {
//                    throw new QuException(-1, "编码输入非法，请重新输入");
//                }
                List<MaterialTypeMap> materialTypeMaps = materialTypeMapMapper.findExist(materialTypeMap.getMapRule(),null);
                if(materialTypeMaps.size()>0){
                    throw new QuException(-1,"该编码已存在，请不要重复创建");
                }
                materialTypeMapMapper.insert(materialTypeMap);
            }
        }
        return ResultUtils.success();
    }

    /**
     * 原材料编辑
     *
     * @param materialTypeMapMix
     * @return
     */
    @Override
    public Result update(MaterialTypeMapMix materialTypeMapMix) {
        //增加的情况
        List<MaterialTypeMap> materialTypeMapsInsert = materialTypeMapMix.getMaterialTypeMapListInsert();
        if(materialTypeMapsInsert.size()>0){
            for(MaterialTypeMap materialTypeMap:materialTypeMapsInsert){
                List<MaterialTypeMap> materialTypeMaps = materialTypeMapMapper.findExist(materialTypeMap.getMapRule(),null);
                if(materialTypeMaps.size()>0){
                    throw new QuException(-1,"该编码已存在，请不要重复创建");
                }
                materialTypeMapMapper.insert(materialTypeMap);
            }
        }
        //修改的情况
        List<MaterialTypeMap> materialTypeMapsUpdate = materialTypeMapMix.getMaterialTypeMapListUpdate();
        if(materialTypeMapsUpdate.size()>0){
            for(MaterialTypeMap materialTypeMap:materialTypeMapsUpdate){
                List<MaterialTypeMap> materialTypeMaps = materialTypeMapMapper.findExist(materialTypeMap.getMapRule(),materialTypeMap.getId());
                if(materialTypeMaps.size()>0){
                    throw new QuException(-1,"该编码已存在，请不要重复修改");
                }
                materialTypeMapMapper.update(materialTypeMap);
            }
        }
        //删除的情况
        List<MaterialTypeMap> materialTypeMapsDel = materialTypeMapMix.getMaterialTypeMapListDel();
        if(materialTypeMapsDel.size()>0){
            for(MaterialTypeMap materialTypeMap:materialTypeMapsDel){
                materialTypeMapMapper.updateDel(materialTypeMap);
            }
        }
        return ResultUtils.success();
    }

    /**
     * 原材料查询
     *
     * @param mapRule
     * @return
     */
    @Override
    public Result findList(Byte materalType, String mapRule, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<MaterialTypeMapForPage> list =  materialTypeMapMapper.findList(materalType);
        PageInfo pageInfo = new PageInfo(list);
        List<MaterialTypeMapForPage> pages = pageInfo.getList();
        for (MaterialTypeMapForPage m:
         pages) {
            m.setMaterialTypeRules(this.materialTypeMapMapper.findRuleToType(mapRule,m.getMateralType()));
        }
        return ResultUtils.success(pageInfo);
    }
}
