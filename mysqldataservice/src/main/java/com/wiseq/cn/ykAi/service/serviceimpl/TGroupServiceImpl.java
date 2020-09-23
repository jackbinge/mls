package com.wiseq.cn.ykAi.service.serviceimpl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.webview.Department;
import com.wiseq.cn.entity.ykAi.TGroup;
import com.wiseq.cn.entity.ykAi.TUser;
import com.wiseq.cn.ykAi.dao.TGroupMapper;
import com.wiseq.cn.ykAi.dao.TUserMapper;
import com.wiseq.cn.ykAi.service.TGroupService;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

import static com.wiseq.cn.utils.RegularCheck.RegexMatchesl;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:
 */
@Service
public class TGroupServiceImpl implements TGroupService {

    @Autowired
    TGroupMapper tGroupMapper;

    @Autowired
    TUserMapper tUserMapper;

    /**
     * 查询组织结构树
     *
     * @param code
     * @param name
     * @return
     */
    @Override
    public Result findGroupTree(String code, String name) {
        return ResultUtils.success(makeTree(tGroupMapper.findGroupTree(code, name)));
    }

    /**
     * 新增组织(当前组织下该组织名称唯一)
     *
     * @param tGroup
     * @return
     */
    @Override
    public Result insert(TGroup tGroup) {
        if (null != tGroup) {
            //只是组织下面校验（废弃）
            //List<TGroup> tGroupList = tGroupMapper.findExist(tGroup.getName(), tGroup.getParentId());
            List<TGroup> tGroupList = tGroupMapper.findExist(tGroup.getName(), null);
            if (tGroupList.size() > 0) {
                return  ResultUtils.error(-1, "当前组织名称已存在，请勿重复创建！");
            }
            tGroupMapper.insert(tGroup);
        }
        return ResultUtils.success();
    }

    /**
     * 删除组织
     * 校验该组织下是否还有关联人员，如果有，则不予删除
     *
     * @param tGroup
     * @return
     */
    @Override
    public Result tGroupDel(TGroup tGroup) throws QuException {
        if (null != tGroup) {
            //校验该组织下是否还有人员
            List<TUser> tUserList = tUserMapper.findStillExist(tGroup.getId());
            //校验有没有子组织
            List<TGroup> findChildExist = tGroupMapper.findChildExist(tGroup.getId());

            if (tUserList.size() > 0) {
                throw new QuException(-1, "组织内仍有人员数据，不可删除！");
            }
            if(findChildExist.size() > 0){
                return ResultUtils.error(1,"该组织下面有未删除组织不能删除");
            }
            tGroupMapper.updateDel(tGroup);
        }
        return ResultUtils.success();
    }

    /**
     * 查询生产车间编码页面（仅展示第四级有编码的数据）
     *
     * @param id
     * @return
     */
    @Override
    public Result findProductionCodeList(Long id) {
        return tGroupMapper.findProductionCodeList(id);
    }

    /**
     * 查询生产车间无编码列表（仅展示第四级无编码的数据）
     *
     * @param
     * @return
     */
    @Override
    public Result findProductionNoCode() {
        return tGroupMapper.findProductionNoCodeList();
    }

    /**
     * 新增组织编码数据（）
     *
     * @param tGroup
     * @return
     */
    @Override
    public Result productionCodeinsert(TGroup tGroup) {
        String code = tGroup.getCode();
//        RegexMatchesl(code);
        List<TGroup> tGroupList = tGroupMapper.findCodeExist(code);
        if (tGroupList.size() > 0) {
            throw new QuException(-1, "该编码已存在！");
        }
        return tGroupMapper.productionCodeinsert(tGroup);
    }

    @Override
    public Result productionCodeUpdate(TGroup tGroup) {
        String code = tGroup.getCode();
//        RegexMatchesl(code);
        List<TGroup> tGroupList = tGroupMapper.findCodeExist(code);
        if (tGroupList.size() > 0) {
            throw new QuException(-1, "该编码已存在！");
        }
        return tGroupMapper.productionCodeUpdate(tGroup);
    }

    /**
     * 生产车间列表
     * @return
     */
    @Override
    public Result productionShopList(){
        return ResultUtils.success(tGroupMapper.getProductionList());
    }


    /**
     * 获取还没有easId的车间列表
     * @return
     */
    @Override
    public Result getNoMapEasIdShopList() {
        return ResultUtils.success(tGroupMapper.getNoMapEasIdShopList());
    }


    /**
     * 修改EAS组织ID
     * @return
     */
    @Override
    public Result updateGroupEasId(String mapEasId, Long id){
        List<LinkedHashMap<String, Object>> list = tGroupMapper.findExit(mapEasId,id);
        if(list.size()>0){
            return ResultUtils.error(1,"编码重复");
        }
        tGroupMapper.updateMapEasId(mapEasId,id);
        return ResultUtils.success();
    }

    /**
     * 获取有EAS的生产车间
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public Result getProductionMapEASIdList(Long id, Integer pageNum, Integer pageSize){
        if(null==pageNum){
            return ResultUtils.success(tGroupMapper.getProductionMapEASIdList(id));
        }
        PageHelper.startPage(pageNum,pageSize);
        PageInfo pageInfo = new PageInfo(tGroupMapper.getProductionMapEASIdList(id));
        return ResultUtils.success(pageInfo);
    }

    /**
     * 通过组织ID查询组织角色及用户列表
     * @param groupId
     * @param username
     * @return
     */
//    @Override
//    public Result findTGroupUserRoleList(String groupId, String username) {
//        return tGroupMapper.findTGroupUserRoleList(groupId,username);
//    }

    /**
     * 组装树
     * 这个用来构建第一层，就是没有父的那一层。
     * @param tGroupList
     * @return
     */
    private List<TGroup> makeTree(List<TGroup> tGroupList) {
        List<TGroup> treeLi = new ArrayList<>();
        /* 适配转换 */
        for (TGroup tGroup : tGroupList) {
            //
            if (0 == tGroup.getParentId()) {
                TGroup meta = new TGroup();
                meta.setId(tGroup.getId());
                meta.setName(tGroup.getName());
                meta.setCode(tGroup.getCode());
                meta.setParentId(tGroup.getParentId());
                meta.setMapEasId(tGroup.getMapEasId());
                meta.setParentPath(tGroup.getParentPath());
                meta.setLevel(tGroup.getLevel());
                meta.setIsDelete(tGroup.getIsDelete());
                meta.setCreateTime(tGroup.getCreateTime());
                treeBuilder(meta, tGroupList);
                treeLi.add(meta);
            }
        }
        return treeLi;
    }

    /**
     * 构建数据树
     * 递归构建子树
     *
     * @param tGroup
     * @param tGroupLists
     */
    private void treeBuilder(TGroup tGroup, List<TGroup> tGroupLists) {
        for (TGroup child : tGroupLists) {
            Long parentId = child.getParentId();
            if (tGroup.getId().equals( parentId)) {
                TGroup Group = new TGroup();
                Group.setId(child.getId());
                Group.setName(child.getName());
                Group.setCode(child.getCode());
                Group.setParentId(child.getParentId());
                Group.setMapEasId(child.getMapEasId());
                Group.setParentPath(child.getParentPath());
                Group.setLevel(child.getLevel());
                Group.setIsDelete(child.getIsDelete());
                Group.setCreateTime(child.getCreateTime());
                treeBuilder(Group, tGroupLists);
                tGroup.getChildren().add(Group);
            }
        }
    }



}
