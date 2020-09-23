package com.wiseq.cn.ykAi.service.serviceimpl;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.utils.ListUtil;
import com.wiseq.cn.ykAi.dao.TColorRegionDtlMapper;
import com.wiseq.cn.ykAi.dao.TColorRegionMapper;
import com.wiseq.cn.ykAi.dao.TOutputRequirementsDtlMapper;
import com.wiseq.cn.ykAi.service.TColorRegionDtlService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/6     lipeng      原始版本
 * 文件说明:  色区明细
 */
@Service
@Transactional
public class TColorRegionDtlServiceImpl implements TColorRegionDtlService {
    @Autowired
    TColorRegionMapper tColorRegionMapper;
    @Autowired
    TColorRegionDtlMapper tColorRegionDtlMapper;
    @Autowired
    TOutputRequirementsDtlMapper tOutputRequirementsDtlMapper;

    /**
     * 色区详情删除
     *
     * @param tColorRegionDtlList
     * @return
     */
    @Override
    public Result updateDelbunch(List<TColorRegionDtl> tColorRegionDtlList) {
        for (TColorRegionDtl tColorRegionDtl : tColorRegionDtlList) {
            tColorRegionDtlMapper.update(tColorRegionDtl);
        }
        return ResultUtils.success();
    }
    //椭圆
    private final static  Byte ELLIPSE = 0;
    //四边形
    private final static  Byte QUADRILATERAL = 1;


    /**
     * 色区详情新增（色容差名称唯一性验证）
     *
     * @param tColorRegionGroup
     * @return
     */
    @Override
    public Result tColorRegionGroupInsert(TColorRegionGroup tColorRegionGroup) throws QuException {
        TColorRegion tColorRegion = tColorRegionGroup.getTColorRegion();
        if(tColorRegion == null ){
            throw new QuException(-1, "数据为空无法创建");
        }
        TColorRegionDtl tColorRegionDtl = tColorRegionGroup.getTColorRegionDtl();
        if (null != tColorRegion) {
            //色容差类型
            List<TColorRegion> tColorRegions = tColorRegionMapper.findExist(tColorRegion.getName(),srcTypeID,tColorRegion.getTypeMachineId());
            if (tColorRegions.size() > 0) {
                throw new QuException(-1, "该名称已存在，请勿重复创建");
            }

            //List<TColorRegionDtl> tColorRegionDtlList = tColorRegion.getTColorRegionDtl();
            Byte shpe = tColorRegionDtl.getShape();
            List<XYDTO> xydtoList0 = new ArrayList<XYDTO>(Arrays.asList(new XYDTO(tColorRegionDtl.getX1(),tColorRegionDtl.getY1()),
                                                                        new XYDTO(tColorRegionDtl.getX2(),tColorRegionDtl.getY2()),
                                                                        new XYDTO(tColorRegionDtl.getX3(),tColorRegionDtl.getY3()),
                                                                        new XYDTO(tColorRegionDtl.getX4(),tColorRegionDtl.getY4())));
            //四边形
            if(shpe.equals(QUADRILATERAL)){
                List<QuadrilateralDTO> quadrilateralDTOList = tColorRegionMapper.findExistColorRegionQuadrilateral(tColorRegion.getTypeMachineId());
                for (QuadrilateralDTO t:
                quadrilateralDTOList) {
                    List<XYDTO> xydtoList1 = t.getXydtoList();
                    if(ListUtil.isListEqual(xydtoList0,xydtoList1)){
                        throw  new QuException(-1,"该机种已经存在坐标参数与其一致的四边形色容差");
                    }
                }
            }
            if(shpe.equals(ELLIPSE)){
             Integer count =   tColorRegionMapper.findExistColorRegionEllipse(tColorRegion.getTypeMachineId(),
                        tColorRegionDtl.getA(),
                        tColorRegionDtl.getB(),
                        tColorRegionDtl.getX(),
                        tColorRegionDtl.getY(),
                        tColorRegionDtl.getAngle());
             if(count != null && !count.equals(0)){
                throw new QuException(-1,"该机种已经存在参数与其一致的椭圆色容差");
             }
            }

            tColorRegionMapper.insert(tColorRegion);
        }


        tColorRegionDtl.setColorRegionId(tColorRegion.getId());
        if (null != tColorRegionDtl) {
            tColorRegionDtlMapper.insertSelective(tColorRegionDtl);
        }
        return ResultUtils.success();
    }





    /**
     * 查询色区详细信息
     *
     * @param colorRegionId
     * @return
     */
    @Override
    public TColorRegionDtl findtColorRegionDtlList(Long colorRegionId, String name, Byte shape) {
        return tColorRegionDtlMapper.selectByPrimaryKey(colorRegionId, name, shape);
    }

    private Byte srcTypeID = 0;//色容差类型ID
    private Byte skTypeID = 1;//色块类型ID
    /**
     * 新增色区色块
     *
     * @param tColorRegionGroupSK
     * @return
     */
    @Override
    @Transactional
    public Result tColorRegionGroupSKInsert(TColorRegionGroupSK tColorRegionGroupSK) throws QuException{
        TColorRegion tColorRegion = tColorRegionGroupSK.getTColorRegion();
        if (null != tColorRegion) {
            //色容差类型
            List<TColorRegion> tColorRegions = tColorRegionMapper.findExist(tColorRegion.getName(),skTypeID,tColorRegion.getTypeMachineId());
            if (tColorRegions.size() > 0) {
                throw new QuException(-1, "该名称已存在，请勿重复创建");
            }
            tColorRegionMapper.insert(tColorRegion);
        }
        List<TColorRegionDtl> tColorRegionDtlList = tColorRegionGroupSK.getTColorRegionDtlList();
        if (tColorRegionDtlList.size() > 0) {
            for(TColorRegionDtl tColorRegionDtl:tColorRegionDtlList){
                List<TColorRegionDtl> tColorRegionDtls = tColorRegionDtlMapper.findExist(tColorRegionDtl.getName(),tColorRegion.getId());
                if(tColorRegionDtls.size()>0){
                    throw new QuException(-1,"该色块下细分色块名称已存在，请勿重复创建");
                }
                tColorRegionDtl.setColorRegionId(tColorRegion.getId());
                tColorRegionDtlMapper.insertSelective(tColorRegionDtl);
            }
        }
        return ResultUtils.success();
    }

    /**
     * 修改色块系列
     * @param skInfoDTOS
     * @return
     */
    @Override
    public Result updateSk(List<SKInfoDTO> skInfoDTOS) {
        tColorRegionDtlMapper.updateSkBatch(skInfoDTOS);
        return ResultUtils.success();
    }

    /**
     * 修改椭圆
     * @param tyInfoDTO
     * @return
     */
    @Override
    public Result updateTy(TyInfoDTO tyInfoDTO) {
        tColorRegionDtlMapper.updateTy(tyInfoDTO);
        //同步出货要求表
        TOutputRequirementsDtl tOutputRequirementsDtl = new TOutputRequirementsDtl();
        tOutputRequirementsDtl.setColorRegionId(tyInfoDTO.getColorRegionId());
        tOutputRequirementsDtl.setCpX(tyInfoDTO.getX());
        tOutputRequirementsDtl.setCpY(tyInfoDTO.getY());
        tOutputRequirementsDtlMapper.updateByColorRegionIdSelective(tOutputRequirementsDtl);
        return ResultUtils.success();
    }

    /**
     * 修改方形
     * @param fkInfoDTO
     * @return
     */
    @Override
    public Result updateFk(FkInfoDTO fkInfoDTO) {
        tColorRegionDtlMapper.updateFk(fkInfoDTO);
        return ResultUtils.success();
    }
}
