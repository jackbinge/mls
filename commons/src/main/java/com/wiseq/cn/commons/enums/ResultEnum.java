package com.wiseq.cn.commons.enums;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 自定义枚举，可以根据range进行自定义
 **/
public enum  ResultEnum {
    //0-999 正常
    NOERROR(0, "成功！"),
    //1000-1999
    SYSTEM_ERR(1001, "系统错误"),
    DATABASE_ERR(1002, "数据库异常"),
    TOKEN_ISNULL(1003,"token错误"),
    NULLDATA(1004,"数据不存在"),
    NETWORK_ERR(1005,"数据加载延迟，请刷新页面"),

    //2000-2999
    NUMBERIC_FORMAT_ERR(2000, "数字格式错误"),
    DATE_FORMAT_ERR(2000, "日期格式错误"),
    TIMESTAMP_FORMAT_ERR(2001, "时间戳格式错误"),
    DESENCRYPT_ERR(2002, "DES转化异常"),
    TOKEN_MODULENAME_ERR(2003, "Token模块名称缺失"),
    TOKEN_FUNENAME_ERR(2004, "Token方法名称缺失"),
    TOKEN_UIDNULL_ERR(2005, "UID缺失"),
    UNNORMAL_INPUT_ERROR(2006,"未知的输入错误"),
    //3000-3999
    PARAM_ISNULL(3000, "传入对象为空"),
    USERNAME_ISNULL(3001, "用户名输入非法"),
    PASSWORD_ISNULL(3002, "用户密码输入非法"),
    USERNAME_LENERROR(3003, "用户名长度最大为10"),
    PASSWORD_LENERROR(3004, "密码长度为6-8位"),
    HAVE_SAMENAME(3005, "存在相同账号"),
    ROLENAME_ERROR(3006, "角色名不合法"),
    ROLECNAME_ERROR(3007, "中文角色名不合法"),
    NOUSER_ERROR(3008, "系统不存在该用户"),
    USERPASSWORD_ERROR(3009, "用户密码不正确"),
    UPDATEPASSWORD_ERROR(3010, "旧密码输入不正确"),
    ROLEHAVEDEL_ERROR(3011, "角色ID对应的角色已经删除"),
    STATIONHAVEDEL_ERROR(3012, "岗位ID对应的岗位已经删除"),
    DEPARTHAVEDEL_ERROR(3013, "部门ID对应的部门已经删除"),
    ROLENAME_SAMENAME(3014, "存在相同角色名"),
    ROLECNAME_SAMENAME(3015, "存在相同角色中文名"),
    USERNAME_PASSWORDEROR(3016,"用户名或密码不正确"),

    //5000-6000
    PRIMARY_KEY_ERR(5000,"主键错误"),
    PRIMARY_KEY_ISNULL_ERR(5001,"主键为空"),
    MISSING_DATA_ERR(5002,"数据不完整"),
    IP_ERR(5003,"错误的IP格式"),
    DEVICESNAME_REPEAT(5004,"设备名字重复"),
    DEVICESIP_REPEAT(5005,"设备IP重复"),
    FIELDDATA_REPEAT(5006,"表名或字段名重复"),
    TABLENAME_REPEAT(5007,"表名或字段名非法命名"),
    NODEFAILE_REPEAT(5008,"该父节点不能添加子节点，添加子节点会导致表名重复，请先修改父节点英文名"),
    NOChinese(5007,"不能有汉字"),
    NAME_ERR(5008,"非法的姓名格式"),
    TABLE_ERR(5009,"创建表已经存在"),//需要前端处理的code,慎用
    SPARK_ERR(5010,"SPARK数据处理失败"),
    //6000-6999
    NULL_DATA(6000,"数据不存在"),
    UNCOMPLETE_DATA(6001,"数据不完整"),
    CANT_DELETE(6003,"无法删除"),
    UNABLE_TO_CALL(6004,"无法调用"),
    PARAM_ERR(6002,"参数错误"),
    TABLE_NO_EXISTS(6005,"表不存在"),

    REPEAT_DATA_ERR(7000,"重复数据，禁止入库"),
    INVALID_DATA(7001," 非法数据"),
    noexist_device(7002,"设备不存在"),
    EMPTYNAME_DEVICE(7003,"设备名字为空"),
    ENPTYNAME_COLLECTION_POINT(7004,"采集点名称为空"),
    EMPTY_NAME_TABLE_NAME(7005,"表名称为空"),
    EMPTY_NAME_COLLECT_PARAM(7006,"采集参数名称为空"),
    NAME_REPEAT(7007,"名称重复"),
    ENTRUSTFLOW_ERR(7008, "该流程已被委托，不能进行重复委托"),
    ROUTER_REPEAT(7009, "菜单路由重复"),
    DATA_IS_CALLED(7010,"此工序有流程卡在使用，无法删除"),
    NODE_IS_PARENT(7011,"该节点为父节点，无法删除，请先删除子节点"),
    Name_EMPTY(7012,"名称为空"),
    LASERMARK_REPEAT(7013,"镭刻号重复"),
    VERIFICATION_FILM_EXIST(7014,"验证片重复"),
	MOCVD_REPEAT(7015,"机台重复添加"),
    REPEAT_NUMBER(7016,"验证片单号重复"),
    BOXNO_REPEAT(7017,"出厂盒号重复"),
    BATCHNO_REPEAT(7018,"批次号重复"),
    ISEABLEDEL_REPEAT(7019,"当前批次已经投入生产，无法撤销！"),
    CONTROL_SLICE(7020,"控制片重复"),
    EXPORT_DATA_FAIL(7021,"导出失败"),
    EXPORT_DATA_SUCCESS(7022,"导出成功"),
    FAILURE(-2,"数据更新失败"),
    FILE_NAME_PATH_EMPTY(7023,"文件名或者路径为空"),
    RUN_MSG_NON_EXISTENT(7024,"上传失败，当前run信息不存在，请检查后重试！"),
    CALCULATION_DETERMINE(7025,"上传失败，当前run已经计算判定，无法覆盖"),
    QUANTITY_DISCREPANCY(7026,"上传失败，文件wafer数量与投片数量不符，是否需要继续上传？"),
    FILE_EXISTS_RUN(7027,"当前run数据已存在，是否确认覆盖！"),
    WAFER_MSG_NON_EXISTENT(7028,"上传失败，当前wafer信息不存在，请检查后重试！"),
    FILE_EXISTS_WAFER(7029,"当前wafer数据已存在，是否确认覆盖！"),
    EDITION_NOT_LATEST(7030,"当前已不是最新版本不可修改！"),
    CODE_REPEAT(7031,"编号重复"),
    NOT_YET_GROWN(7032,"上传失败，当前run尚未生长完成，不可上传测试数据！"),
    DISK_NUMBER_REPEAT(7033,"盘号重复"),
    MODEL_SIZE_REPEAT(7034,"同一产品型号同一尺寸数据重复"),
    FP_CLASSIFY_REPEAT(7035,"副品分类名称重复"),
    STANDARD_NAME_REPEAT(7036,"标准名称重复"),
    TEST_CONFIG_REPEAT(7037,"同一芯片不可重复测试配置"),
    RECIVE_DATA_NOT_EXIST(7038,"该扫描数据还未接片或者在本次操作流程中已经传片，请确认！"),
    DELIVER_DATA_NOT_EXIST(7039,"该扫描数据所在流程卡的上一站点还未传片或者本站点已经接片，请确认！"),
    PLATE_NOT_EXIT(7040,"研磨盘信息不存在，请确认！"),
    PLATE_NOT_STOP(7041,"该盘的片子还未全部下片，不可上片"),
    PLATE_NOT_UP_SLICE(7042,"该盘还没有上片数据"),
    PLATE_NOT_ADHESIVE(7043,"该盘还没有粘片数据"),
    PLATE_NOT_GrIND(7044,"该盘还没有研磨数据"),
    PLATE_NOT_POLISH(7045,"该盘还没有抛光数据"),
    PLATE_NOT_CLEAN(7046,"该批次号还没有清洗数据"),
    WAFER_REPEAT_BILL(7047,"wafer数据在其他验证片单中存在"),
    BILL_NO_REPEAT(7048,"异常单号重复"),
    BATCH_NO_NOT_EXIT(7049,"该扫描数据不存在，请确认后，再扫描！"),
    BATCH_NO_FULL_UP(7050,"该批次号所接片子已经全数上片"),
    BATCH_NO_NOT_FULL_UP(7051,"该批次号所接片子还未全数上片"),
    GlueSpecs(7052,"该胶水规格已经存在，请勿重复创建"),
    GlueSpec(7053,"胶水规格不能为空"),
    ratioB(7054,"B胶水比例值不能为空"),
    ratioA(7055,"A胶水比例值不能为空"),
    tScaffolds(7056,"该支架规格已存在，请勿重复创建"),
    tScaffold(7057,"该支架规格已存在，请勿重复创建"),
    Param3(7058,"棱台顶长/圆台高度不能为空"),
    Param2(7059,"棱台底长/顶部直径不能为空"),
    Param1(7060,"棱台底宽/底部直径不能为空"),
    IsCircular(7061,"支架类型不能为空"),
    ScaffoldSpec(7062,"支架规格不能为空"),
    tDiffusionPowders(7063,"该扩散粉规格已经存在,请勿重复修改"),
    tDiffusionPowder(7064,"该扩散粉规格已经存在"),
    AddProportion_k(7065,"扩散粉密度不能为空"),
    Density_k(7066,"扩散粉密度不能为空"),
    AntiStarchSpecs(7067,"该抗沉淀粉规格已存在，请勿重复创建！"),
    AddProportion(7068,"添加比例不能为空！"),
    Densitys(7069,"密度不能为空！"),
    AntiStarchSpec(7070,"抗沉淀粉规格不能为空！"),
    PeakWavelength(7071,"峰值波长不能为空！"),
    testCondition(7072,"测试条件不能为空"),
    Density(7073,"考核项次序值不能为空"),
    Vf(7074,"正向电压最值不能为空"),
    Iv(7075,"发光强度最值不能为空"),
    Lumen(7076,"亮度最值不能为空"),
    DiffusionPowderSpec(7077,"扩散粉规格不能为空"),
    ChipSpec(7078,"芯片规格名称不能为空"),
    tPhosphorSpec(7078,"荧光粉规格不可为空！"),
    PROHIBITED_STATE(7079,"状态禁止，不可更改！"),
    Wl(7080,"波段最值不可为空"),
    ENVPOINTS_WORKSHOPID(7081,"加工环境车间名称不能修改"),
    tChipWlRank(7082,"该波段已存在，请勿重复创建"),
    tColorRegionDtl(7083,"该机种色区系列已存在，请勿重复创建"),
    tChip(7084,"该规格芯片已经存在，请勿重复创建"),
    tChips(7085,"该规格芯片已经存在，请勿重复修改"),
    PhosphorSpec(7086,"该荧光粉规格已存在，请勿重复创建"),
    tEqptList(7087,"该资产编号和资产位置已存在，请勿重复新增"),
    tEqptValves(7088,"该阀体名和曾已存在，请勿重复创建！"),
	//zhaoxin
    MACHINEMISS(9000,"机种规格不存在，请新增"),
    MACHINEDISABLE(9001,"机种被禁用，重新启用"),
    SCAFFOLDMISS(9002,"支架不存在，请新增"),
    SCAFFOLDDISABLED(9003,"支架被禁用，重新启用"),
    CHIPMISS(9004,"芯片不存在，请新增"),
    CHIPDISABLED(9005,"芯片被禁用，重新启用"),
    GLUEMISS(9006,"胶水不存在，请新增"),
    GLUEDISABLED(9007,"胶水被禁用，重新启用"),
    PHOSPHERMISS(9008,"荧光粉不存在，请新增"),
    PHOSPHERDISABLED(9009,"荧光粉被禁用，重新启用"),
    ANTIATARCHMISS(9010,"抗沉淀粉不存在，请新增"),
    ANTIATARCHDISABLED(9011,"抗沉淀粉被禁用，重新启用"),
    DIFFUSIONPOWDERMISS(9012,"扩散粉不存在，请新增"),
    DIFFUSIONPOWDERDISABLED(9013,"扩散粉被禁用，重新启用"),
    BOMMISS(9014,"BOM组合不存在，创建为新的BOM组合"),
    COLORREGIONMISS(9015,"当前机种不存在色区，请新增"),
    OUTPUTMISS(9016,"当前机种不存在出货要求，请新增"),
    NOBOMSET(9017,"请完成机种的BOM组合设置！"),
    TOUCHANSUCCESS(8888,"投产成功"),
    TOUCHANERROR(8887,"投料异常，请联系系统管理员处理"),
    PARMERROR(8886,"投料异常，请联系系统管理员处理"),
    PRODUCTERROR(8885,"投料异常，请联系系统管理员处理"),
    OUTPUTBEFORRULEMISS(8884,"前测规则不存在，请新增"),
    OUTPUTNBAKERULEMISS(8883,"非正常烤规则不存在，请新增"),
    FILETYPEERROR(8882,"上传失败，文件格式异常"),
    FILEDATAERROR(8881,"上传失败，文件内有效数据小于3个"),
    UPLOADERROR(8880,"系统出错，请联系系统管理员处理"),
    MODEl_REPEAT(8001,"生产搭配数重复"),
    UNKNOWN_ERR(-1, "未知错误");



    private int state;
    private String stateInfo;

    ResultEnum(int state, String stateInfo) {
        this.state = state;
        this.stateInfo = stateInfo;
    }

    public int getState() {
        return state;
    }

    public String getStateInfo() {
        return stateInfo;
    }

    public static ResultEnum stateOf(int index) {
        for (ResultEnum state : values()) {
            if (state.state==index) {
                return state;
            }
        }
        return null;
    }


}
