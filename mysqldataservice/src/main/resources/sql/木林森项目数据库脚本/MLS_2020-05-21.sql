-- create by 毛毅，蒋百灵
-- version 0.0.14
-- 数据库设计中 't' 开头的表代表基础表，'bs'开头的表代表业务表,'d'开头的表代表采集数据获取的表，‘eas开头的表代表从eas同步的基础信息表’

-- 修改点：
-- 修改d_upload_file 增加设备阀体
-- 修改d_file_summary 增加ra lm等统计信息
-- 修改d_file_color_region_summary
-- 修改 eas_wo
-- 修改 eas_wo_dtl
-- 修改 bs_model_factor
-- 增加 bs_model_data_source
-- 增加 bs_model_recommend_result
-- 芯片等级由int - varchar(10)
-- t_type_machine 显色指数最大值和最小值都由int->double
-- t_type_machine ra_target 由int 改为 double
-- 修改d_upload_file 增加 file_state

-- 通过" select table_name  ,TABLE_COMMENT from information_schema.tables where table_schema='yk_ai’ "查看当前库的所有表和备注
-- 新加荧光粉类型表和荧光粉表
-- ---------------------------------------------------------------------------------------------------------------------
-- 创建数据库
/*drop database if exists yk_ai_2020;
create database yk_ai_2020 default char set utf8 collate utf8_general_ci;
use yk_ai_2020;*/


drop database if exists yk_ai_test;
create database yk_ai_test default char set utf8 collate utf8_general_ci;
use yk_ai_test;


-- ---------------------------------------------------------------------------------------------------------------------
create table t_group
(
    id          bigint      not null auto_increment primary key,
    parent_id   bigint comment '父ID',
    code        varchar(50) comment '编码',
    name        varchar(50) not null,
    map_eas_id  varchar(64) comment '关联至eas组织结构id',
    parent_path varchar(255) comment '父级路径',
    level       varchar(64) comment '组织级别,建议创建一张表，关联相关id',
    is_delete   bool        not null default false comment 'false正常、true 删除',
    create_time datetime    not null default now() comment '创建时间'
) comment ='组织结构';

-- ---------------------------------------------------------------------------------------------------------------------
-- 权限角色
create table t_user
(
    id          bigint      not null auto_increment primary key,
    group_id    bigint      not null comment '组织id',
    username    varchar(32) not null comment '用户名',
    account     varchar(32) not null comment '账户',
    password    varchar(32) not null,
    disabled    bool        not null default false comment '是否禁用 false 不禁用 true 禁用',
    is_delete   bool        not null default false comment 'false正常、true 删除',
    create_time datetime    not null default now() comment '创建时间',
    constraint fk_user_group_id foreign key (group_id) references t_group (id)
) comment ='用户';

create table t_role
(
    id          bigint      not null auto_increment primary key,
    group_id    bigint      not null comment '组织id',
    name        varchar(32) not null,
    remark      varchar(128),
    disabled    bool        not null default false comment 'false正常、true 删除',
    create_time datetime    not null default now() comment '创建时间',
    constraint fk_role_group_id foreign key (group_id) references t_group (id)
) comment ='角色';

-- 菜单
create table t_privilege
(
    id          bigint       not null auto_increment primary key,
    name        varchar(50)  not null COMMENT '功能模块名称，页面名称，导航名称',
    parent_id   bigint comment '父菜单Id',
    router      varchar(100) not null COMMENT '路由名称',
    router_path varchar(100) not null COMMENT '路由路径',
    kind        tinyint      not null default 0 comment '标识该权限是否为按钮级别，1 按钮级别 0 菜单级别'
) COMMENT = '系统菜单表';


create table t_user_role
(
    id      bigint not null auto_increment primary key,
    user_id bigint not null,
    role_id bigint not null,
    constraint fk_user_id foreign key (user_id) references t_user (id),
    constraint fk_role_id foreign key (role_id) references t_role (id)
) comment ='用户角色表';

create table t_role_privilege
(
    id           bigint not null auto_increment primary key,
    role_id      bigint not null,
    privilege_id bigint not null,
    constraint fk_role_privilege_id foreign key (role_id) references t_role (id),
    constraint fk_privilege_role_id foreign key (privilege_id) references t_privilege (id)
) comment ='角色权限表';


-- ---------------------------------------------------------------------------------------------------------------------
-- 点胶机
create table t_eqpt
(
    id          bigint      not null auto_increment primary key,
    eqpt_code   varchar(32) comment '设备编码',
    positon     int         not null comment '设备位置编号',
    group_id    bigint      not null comment '组织架构ID',
    pinhead_num int comment '针头数量',
    disabled    bool        not null default false comment '是否禁用 false 不禁用 true 禁用',
    assets_code varchar(32) not null comment '资产编码',
    type        tinyint     not null comment '设备类型,0 点胶设备',
    create_time datetime    not null default now() comment '创建时间',
    is_delete   bool        not null default false comment 'false正常、true 删除'
) comment ='设备';


-- 设备阀体表
create table t_eqpt_valve
(
    id        bigint not null auto_increment primary key,
    eqpt_id   int    not null comment '设备id',
    name      varchar(32) comment '阀体名称',
    remark    varchar(50) comment '备注',
    is_delete bool   not null default false comment 'false正常、true 删除'
) comment = '设备阀体表';

-- ---------------------------------------------------------------------------------------------------------------------
-- 原材料库

-- 芯片表
create table t_chip
(
    id             bigint       not null auto_increment primary key,
    chip_code      varchar(32) comment '芯片编码',
    chip_spec      varchar(32) not null comment '芯片规格',
    chip_rank      varchar(10) comment '芯片等级',
    supplier       varchar(64) comment '供应商',
    test_condition varchar(200)  comment '测试条件(非必填)',
    vf_max         double        comment 'VF正向电压最大值',
    vf_min         double        comment 'VF正向电压最小值',
    iv_max         double        comment 'IV发光强度最大值',
    iv_min         double        comment 'IV发光强度最小值',
    wl_max         double comment '波长最大值',
    wl_min         double comment '波长最小值',
    lumen_max      double        comment '亮度最大值',
    lumen_min      double        comment '亮度最小值',
    fwhm           double comment '半高宽',
    create_time    datetime     not null default now() comment '创建时间',
    is_delete      bool         not null default false comment 'false正常、true 删除',
    disabled       bool         not null default false comment '是否禁用 false 不禁用 true 禁用'
) comment ='芯片';

-- 芯片波段
create table t_chip_wl_rank
(
    id        bigint not null auto_increment primary key,
    name      varchar(32) comment '芯片名字',
    chip_id   bigint not null comment '芯片ID',
    wl_max    double not null comment '波长最大值',
    wl_min    double not null comment '波长最小值',
    is_delete bool   not null default false comment 'false正常、true 删除',
    constraint fk_chip_wl_rank foreign key (chip_id) references t_chip (id)
) comment '芯片波段';

-- 荧光粉类型
create table t_phosphor_type
(
    id bigint not null auto_increment primary key,
    name VARCHAR(32) comment '荧光粉类型名称',
    is_delete bool not null default false comment 'false 正常、true 删除'
)comment = '荧光粉类型';



-- 荧光粉
create table t_phosphor
(
    id                  bigint   not null auto_increment primary key,
    phosphor_code       varchar(32) comment '荧光粉编码',
    phosphor_spec       varchar(32) comment '荧光粉规格',
    supplier            varchar(64) comment '供应商',
    cold_heat_ratio     double comment '冷热比',
    particle_diameter10 double comment '粒径10',
    particle_diameter50 double comment '粒径50',
    particle_diameter90 double comment '粒径90',
    peak_wavelength     double   not null comment '峰值波长',
    density             double   not null comment '密度',
    cie_x               double comment '色坐标_x',
    cie_y               double comment '色坐标_y',
    fwhm                double comment '半高宽',
    create_time         datetime not null default now() comment '创建时间',
    is_delete           bool     not null default false comment 'false 正常、true 删除',
    disabled            bool     not null default false comment '是否禁用 false 不禁用 true 禁用',
    phosphor_type_id    bigint  not null comment '荧光粉类型'
) comment ='荧光粉';

-- 胶水表
create table t_glue
(
    id          bigint   not null auto_increment primary key,
    ratio_a     double   not null comment '固定比例a',
    ratio_b     double   not null comment '固定比例b',
    create_time datetime not null default now() comment '创建时间',
    is_delete   bool     not null default false comment 'false 正常、true 删除',
    disabled    bool     not null default false comment '是否禁用 false 不禁用 true 禁用'
) comment ='胶水';

-- 胶水详情表
create table t_glue_dtl
(
    id            bigint      not null auto_increment primary key,
    glue_id       bigint      not null comment '外键关联胶水表主键',
    glue_type     varchar(32) not null comment '胶水类型 A胶或B胶',
    glue_code     varchar(32) comment '胶水编码',
    glue_spec     varchar(32) comment '胶水规格',
    supplier      varchar(64) comment '供应商',
    viscosity_max double comment '粘度最大值',
    viscosity_min double comment '粘度最小值',
    hardness_max  double comment '硬度最大值',
    hardness_min  double comment '硬度最小值',
    density       double      not null comment '密度',
    create_time   datetime    not null default now() comment '创建时间',
    constraint fk_glue_id foreign key (glue_id) references t_glue (id)
) comment ='胶水详情表';


-- 扩散粉
create table t_diffusion_powder
(
    id                    bigint   not null auto_increment primary key,
    diffusion_powder_code varchar(32) comment '扩散粉编码',
    diffusion_powder_spec varchar(32) comment '扩散粉规格',
    supplier              varchar(64) comment '供应商',
    density               double   not null comment '密度',
    add_proportion        double comment '添加比例',
    create_time           datetime not null default now() comment '创建时间',
    is_delete             bool     not null default false comment 'false 正常、true 删除',
    disabled              bool     not null default false comment '是否禁用 false 不禁用 true 禁用'
) comment ='扩散粉';


-- 抗沉淀粉
create table t_anti_starch
(
    id               bigint   not null auto_increment primary key,
    anti_starch_code varchar(32) comment '抗沉淀粉编码',
    anti_starch_spec varchar(32) comment '抗沉淀粉规格',
    supplier         varchar(64) comment '供应商',
    density          double   not null comment '密度',
    add_proportion   double comment '添加比例',
    create_time      datetime not null default now() comment '创建时间',
    is_delete        bool     not null default false comment 'false 正常、true 删除',
    disabled         bool     not null default false comment '是否禁用 false 不禁用 true 禁用'
) comment ='抗沉淀粉';

-- 支架
create table t_scaffold
(
    id            bigint   not null auto_increment primary key,
    scaffold_code varchar(32) comment '支架编码',
    scaffold_spec varchar(32) comment '支架规格',
    supplier      varchar(64) comment '供应商',
    family        varchar(64) comment '产品系列',
    is_circular   tinyint           default false comment '0圆台1棱台。棱台默认使用1-5到 分别是底宽、底长、顶长、顶宽、和高；圆台使用1-3，分别是底部直径，顶部直径，高度',
    param1        double comment '棱台底宽/底部直径',
    param2        double comment '棱台底长/顶部直径',
    param3        double comment '棱台顶长/圆台高度',
    param4        double comment '棱台顶宽',
    param5        double comment '棱台高',
    create_time   datetime not null default now() comment '创建时间',
    is_delete     bool     not null default false comment 'false 正常、true 删除',
    disabled      bool     not null default false comment '是否禁用 false 不禁用 true 禁用'
) comment ='支架';


-- ---------------------------------------------------------------------------------------------------------------------
-- 机种库
-- ！新加晶体数量
create table t_type_machine
(
    id           bigint      not null auto_increment primary key,
    code         varchar(32) comment '机种编码',
    spec         varchar(32) not null comment '机种规格',
    ra_target    DOUBLE comment '显色指数,目标值/ra系列',
    ra_max       DOUBLE comment '限制范围上限，用于算法显指良率统计',
    ra_min       DOUBLE comment '显色指数下限，用于算法显指良率统计',
    r9           double comment 'R9',
    ct           int comment '色温(k)',
    lumen_lsl    double comment '流明下限',
    lumen_usl    double comment '流明上限',
    wl_lsl       double comment '波长下限',
    wl_usl       double comment '波长上限',
    create_time  datetime    not null default now() comment '创建时间',
    process_type tinyint     not null comment '工艺类型，0单层工艺 1双层工艺',
    remark       varchar(200) comment '备注',
    crystal_number int comment '晶体数量/芯片数量',
    is_delete    bool        not null default false comment 'false正常、true 删除',
    disabled     bool        not null default false comment '是否禁用 false 不禁用 true 禁用'
) comment '机种定义';

-- !机种的默认的物料（除芯片外）
create table t_type_machine_default_other_material
(
    t_type_machine_id bigint comment '机种id',
    limit_phosphor_type      varchar(100) comment '限制使用的荧光粉类型',
    default_scaffold_id         bigint comment '默认支架',
    default_glue_id             bigint comment '默认胶水',
    default_diffusion_powder_id bigint comment '默认的扩散粉',
    default_anti_starch_id      bigint comment '默认抗沉淀粉'
) comment '默认的物料';


-- !机种默认的芯片
create table t_type_machine_default_chip
(
    t_type_machine_id bigint comment '机种id',
    chip_id bigint comment '默认的芯片ID'
) comment '机种默认的芯片';


create table t_type_machine_gule_high
(
    id              bigint  not null auto_increment primary key,
    type_machine_id bigint  not null comment '机种id',
    gule_hight_usl  double  not null comment '胶体高度上限',
    gule_hight_lsl  double  not null comment '胶体高度下限',
    process_type    tinyint not null comment '胶体高度类型，0 用于单层工艺，1用于双从工艺',
    layer           tinyint comment '层次,null 为单层，0 整体胶高 1 底层胶高',
    constraint fk_type_machine_gule_high_id foreign key (type_machine_id) references t_type_machine (id)
) comment '机种点胶高度';


-- ! 添加BOM来源
create table t_bom
(
    id                  bigint      not null auto_increment primary key,
    type_machine_id     bigint      not null comment '机种id',
    bom_code            varchar(32) not null comment 'bom编码',
-- ！    chip_id             bigint      not null comment '芯片波段ID',
    scaffold_id         bigint      not null comment '支架',
    glue_id             bigint      not null comment '胶水',
    diffusion_powder_id bigint comment '扩散粉',
    anti_starch_id      bigint comment '抗沉淀粉',
    create_time         datetime    not null default now() comment '创建时间',
    is_temp             bool                 default false comment 'bom 类型，flase 正常,true 临时',
    is_delete           bool        not null default false comment 'false正常、true 删除',
    bom_type            tinyint     not null default 0 comment 'bom类型 0 对应单层工艺，1 对应多层工艺上层 2 对应多层工艺下层',
    remark              varchar(200) comment '备注',
    bom_source          tinyint     not null default 0 comment 'bom来源 0 EAS投料,1人工建立,2系统推荐',
-- !    constraint fk_chip_id foreign key (chip_id) references t_chip (id),
    constraint fk_scaffold_id foreign key (scaffold_id) references t_scaffold (id),
    constraint fk_bom_glue_id foreign key (glue_id) references t_glue (id),
    constraint fk_diffusion_powder_id foreign key (diffusion_powder_id) references t_diffusion_powder (id),
    constraint fk_anti_starch_id foreign key (anti_starch_id) references t_anti_starch (id),
    constraint t_tpye_machine_bom_id foreign key (type_machine_id) references t_type_machine (id)
) comment ='bom定义';

-- ! 新增 推荐BOM时的机种的目标参数表
create table t_bom_target_parameter
(
    id   bigint not null auto_increment primary key,
    ra_target    DOUBLE comment '显色指数,目标值/ra系列',
    ra_max       DOUBLE comment '限制范围上限，用于算法显指良率统计',
    ra_min       DOUBLE comment '显色指数下限，用于算法显指良率统计',
    r9           double comment 'R9',
    ct           int comment '色温(k)',
    lumen_lsl    double comment '流明下限',
    lumen_usl    double comment '流明上限',
    wl_lsl       double comment '波长下限',
    wl_usl       double comment '波长上限',
    gule_hight_lsl double comment '胶体高度下限',
    gule_hight_usl double comment '胶体高度上限',
    bom_id       bigint not null comment 'bomId',
    constraint   fk_t_bom_target_parameter_bom_id foreign key (bom_id) references t_bom(id)
) comment = '推荐BOM时的机种目标参数';

-- ! 新增 推荐BOM时选择的禁用和必选的荧光粉表
create table t_bom_phosphor_for_recommended
(
    id bigint not null auto_increment primary key ,
    must_use_phosphor_id varchar(10) comment '必须要用的荧光粉',
    prohibited_phosphor_id varchar(32) comment '禁止使用的荧光粉',
    limit_phosphor_type      varchar(100) comment '限制使用的荧光粉类型',
    bom_id bigint
)comment = '推荐BOM时选择的禁用和必选的荧光粉';


-- bom—荧光粉关系表
create table t_bom_Phosphor
(
    id          bigint not null auto_increment primary key,
    bom_id      bigint not null comment 'bom id',
    phosphor_id bigint not null comment '荧光粉id',
    constraint fk_bom_id foreign key (bom_id) references t_bom (id),
    constraint fk_phosphor_id foreign key (phosphor_id) references t_phosphor (id)
) comment 'bom与荧光粉对应关系';


-- bom--芯片关系表 和 机种的晶体数量有关！
create table t_bom_chip
(
    id          bigint not null auto_increment primary key,
    bom_id      bigint not null comment 'bom_id',
    chip_id     bigint not null comment '芯片id'
) comment  'bom与芯片关系表';


-- 出货要求表
create table t_output_requirements
(
    id              bigint      not null auto_increment primary key,
    code            varchar(32) not null comment '出货要求编码',
    type_machine_id bigint      not null comment '机种id',
    output_kind     tinyint     not null comment '出货要求类型 0 色容差类型，1 出货比例类型，2 中心点类型。其中对于同一机种色容差类型出货要求，共用一组前测规则和非正常烤规则，非色容差出货要求，每种出货要求对应一组前测和非正常烤规则',
    is_temp         bool        not null comment '是否时临时出货要求 true 临时 false 正常',
    create_time     datetime    not null default now() comment '创建时间',
    is_delete       bool        not null default false comment 'false正常、true 删除',
    constraint fk_require_type_machime_id foreign key (type_machine_id) references t_type_machine (id)
) comment '机种对应的出货需求,一个机种对应多个出货要求';

-- 出货要求详情表(如果)
create table t_output_requirements_dtl
(
    id                  bigint   not null auto_increment primary key,
    output_require_id   bigint   not null comment '出货要求id',
    cp_x                double comment '中心点x, 对应与output_kind为1，2，1为调用算法计算，2为用户输入',
    cp_y                double comment '中心点y, 对应与output_kind为1，2，1为调用算法计算，2为用户输入',
    ratio_type          double comment '类型，0 等于 、1 小于、 2 小于等于、 3大于、 4 大于等于，对应与output_kind为1时',
    ratio_value         double comment '比值 对应与output_kind为1时',
    color_region_dtl_id bigint comment ' 关联t_color_region_dtl 的id',
    color_region_id     bigint comment '色区表ID主要用于色块中心点类型',
    create_time         datetime not null default now() comment '创建时间',
    constraint fk_output_require_dtl_id foreign key (output_require_id) references t_output_requirements (id)
) comment '出货要求详情';

-- ---------------------------------------------------------------------------------------------------------------------
-- 色区库
create table t_color_region
(
    id                bigint   not null auto_increment primary key,
    type_machine_id   bigint   not null comment '机种id',
    name              varchar(32) comment '色区名称，色块色区名称',
    color_region_type tinyint comment '色区细分类型，0 色容差色区，1 色块色区',
    xrows             int comment '此色块所在行数, 只针对色块色区，色容差色区该字段为空',
    xcolumns          int comment '此色块所在列数，只针对色块色区，色容差色区该字段为空',
    create_time       datetime not null default now() comment '创建时间',
    is_delete         bool     not null default false comment 'false、true 删除',
    disabled          bool     not null default false comment 'false启用、true 禁用',
    constraint fk_color_region_type_machine_id foreign key (type_machine_id) references t_type_machine (id)
) comment ='机种对应的色区';

create table t_color_region_dtl
(
    id              bigint   not null auto_increment primary key,
    color_region_id bigint comment '此色块所属色区ID',
    name            varchar(32) comment '色块名称 如:A ， B ，C，只针对色块类型色区，色容差类型色区该字段为空',
    xrow            int comment '此色块所在行数，只针对色块类型色区，色容差类型色区该字段为空',
    xcolumn         int comment '此色块所在列数，只针对色块类型色区，色容差类型色区该字段为空',
    shape           tinyint comment '色区形状 0 椭圆 1四边 只针对色容差色区，色块类型类型色区该字段为空',
    x1              double comment '左上坐标 x1',
    y1              double comment '左上坐标 y1',
    x2              double comment '右上坐标 x2',
    y2              double comment '右上坐标 y2',
    x3              double comment '右下坐标 x3',
    y3              double comment '右下坐标 y3',
    x4              double comment '左下坐标 x4',
    y4              double comment '左下坐标 y4',
    a               double comment '椭圆长轴',
    b               double comment '椭圆短轴 x',
    x               double comment '椭圆中心点 x',
    y               double comment '椭圆中心点 y',
    angle           double comment '椭圆倾斜角度',
    create_time     datetime not null default now() comment '创建时间',
    is_delete       bool     not null default false comment 'false、true 删除',
    constraint fk_color_region_id foreign key (color_region_id) references t_color_region (id)
) comment ='常规色区-四边形色区';

-- ---------------------------------------------------------------------------------------------------------------------
-- 规则库(模板)
create table t_spc_base_rule
(
    id            bigint       not null auto_increment primary key,
    rule_no       int          not NULL comment '规则编号',
    rule_template varchar(256) not null comment '规则模板',
    m             int,
    n             int,
    create_time   datetime     not null default now() comment '创建时间'
) comment ='SPC预警规则(模板)';


-- 这针对每个机种的SPC规则
create table t_spc_rule
(
    id              bigint  not null auto_increment primary key,
    type_machine_id bigint  not null comment '机种ID',
    qc_point        tinyint not null comment '质控点 0 落bin率 1 △x和△y',
    ucl             double comment '控制上线,只针对良率',
    lcl             double comment '控制下线,只针对良率',
    delta_x_ucl     double comment '控制上线,只针对距离，x',
    delta_x_lcl     double comment '控制下线,只针对距离，x',
    delta_y_ucl     double comment '控制上线,只针对距离，y',
    delta_y_lcl     double comment '控制下线,只针对距离，y',
    cl_optional     tinyint not null default '1' comment '控制限设定方式 0 理论计算，1人工设定',
    disabled        bool    not null default false comment '是否禁用 false 不禁用 true 禁用',
    constraint fk_qc_rule_id foreign key (type_machine_id) references t_type_machine (id)
) comment ='每一个机种对应对应的spc规则';

create table t_spc_rule_dtl
(
    id           bigint not null auto_increment primary key,
    qc_rule_id   bigint not null comment '质控规则',
    base_rule_id bigint not null comment '预警规则ID',
    m            int,
    n            int,
    constraint fk_spc_rule_id foreign key (qc_rule_id) references t_spc_rule (id),
    constraint fk_spc_base_rule_id foreign key (base_rule_id) references t_spc_base_rule (id)
) comment ='每一个机种对应对应的spc规则详细';

create table t_before_test_rule
(
    id        bigint  not null auto_increment primary key,
    rule_kind tinyint not null comment '规则类型， 0 椭圆,1 四边形,2 点,3 等于出货要求中心点，该中心点在在新建机种时，以调用算法算出来',
    a         double comment '椭圆长轴',
    b         double comment '椭圆短轴',
    x         double comment '椭圆中心点x',
    y         double comment '椭圆中心点y',
    angle     double comment '椭圆倾角',
    x1        double comment '左上-坐标 x1',
    y1        double comment '左上-坐标 y1',
    x2        double comment '右上-坐标 x2',
    y2        double comment '右上-坐标 y2',
    x3        double comment '右下-坐标 x3',
    y3        double comment '右下下-坐标 y3',
    x4        double comment '左下-坐标 x4',
    y4        double comment '左下-坐标 y4',
    cp_x      double comment '中心点x',
    cp_y      double comment '中心点x'
) comment ='出货要求对应的前测规则';

create table t_none_bake_test_rule
(
    id        bigint  not null auto_increment primary key,
    rule_kind tinyint not null comment '规则类型， 0 椭圆,1 四边形,2 中心点,3 等于出货要求中心点，该中心点在在新建机种时，以调用算法算出来',
    a         double comment '椭圆长轴',
    b         double comment '椭圆短轴',
    x         double comment '椭圆中心点x',
    y         double comment '椭圆中心点y',
    angle     double comment '椭圆倾角',
    x1        double comment '左上-坐标 x1',
    y1        double comment '左上-坐标 y1',
    x2        double comment '右上-坐标 x2',
    y2        double comment '右上-坐标 y2',
    x3        double comment '右下-坐标 x3',
    y3        double comment '右下下-坐标 y3',
    x4        double comment '左下-坐标 x4',
    y4        double comment '左下-坐标 y4',
    cp_x      double comment '中心点x',
    cp_y      double comment '中心点x'
) comment ='出货要求对应的非正常烤规则';



create table t_output_require_before_test_rule
(
    id                  bigint not null auto_increment primary key,
    before_test_rule_id bigint not null comment '前测规则id',
    output_require_id   bigint not null comment '出货要求id',
    rule_type           tinyint comment '规则类型 0 对应单层工艺，2 对应多层工艺上层 1 对应多层工艺下层',
    is_delete           bool   not null default false comment 'false、true 删除',
    constraint fk_output_requirements_before_test_rule_id foreign key (before_test_rule_id) references t_before_test_rule (id),
    constraint fk_before_test_rule_output_requirements_id foreign key (output_require_id) references t_output_requirements (id)
) comment ='出货要求与前测规则对应关系,单层工艺对应一条前测规则，双层工艺对应两条前测规则';



create table t_output_require_nbake_rule
(
    id                bigint not null auto_increment primary key,
    none_bake_rule_id bigint not null comment '非正常烤规则id',
    output_require_id bigint not null comment '出货要求id',
    rule_type         tinyint         default 0 comment '规则类型 0 对应单层工艺，2 对应多层工艺上层 1 对应多层工艺下层',
    is_delete         bool   not null default false comment 'false、true 删除',
    constraint fk_output_requirements_nbake_rule_id foreign key (none_bake_rule_id) references t_none_bake_test_rule (id),
    constraint fk_nbake_rule_output_requirements_id foreign key (output_require_id) references t_output_requirements (id)
) comment ='出货要求与非正常烤规则对应关系，单层工艺对应一条前测规则，双层工艺对应两条前测规则';

-- ---------------------------------------------------------------------------------------------------------------------
-- 算法模型库,也就是所谓配比库

-- 模型表
create table t_ai_model
(
    id                        bigint   not null auto_increment primary key,
    type_machine_id           bigint   not null comment '机种ID',
    color_region_id           bigint   not null comment '机种色区ID',
    output_require_machine_id bigint   not null comment '机种出货要求ID',
    is_delete                 bool     not null default false comment 'false、true 删除',
    disabled                  bool     not null default false comment '是否禁用 false 不禁用 true 禁用',
    create_time               datetime not null default now() comment '创建时间',
    creator                   bigint   not null comment '模型创建用户',
    constraint fk_ai_model_type_machine_id foreign key (type_machine_id) references t_type_machine (id),
    constraint fk_ai_model_require_id foreign key (output_require_machine_id) references t_output_requirements (id),
    constraint fk_ai_model_color_region_id foreign key (color_region_id) references t_color_region (id)
) comment '算法模型，模型定义：机种（显指、色温、流明、波长），BOM组合（支架型号、AB胶型号、荧光粉组合、芯片型号、芯片波段），色区，出货要求。';

-- ！ 去掉生产搭配波段ID
create table t_model_bom
(
    id              bigint not null auto_increment primary key,
    model_id        bigint not null comment '模型id',
    bom_id          bigint not null comment 'bom id',
-- !   chip_wl_rank_id bigint not null comment '芯片波段ID',
-- !   constraint fk_ai_model_color_chip_wl_rank_id foreign key (chip_wl_rank_id) references t_chip_wl_rank (id),
    constraint fk_ai_model_bom_id foreign key (bom_id) references t_bom (id),
    constraint fk_ai_bom_model_id foreign key (model_id) references t_ai_model (id)
) comment '模型与bom的关系, 单层工艺以一对一，双层工艺一对二';

-- 芯片生产搭配对应的芯片波段
create table t_model_bom_chip_wl_rank
(
    id    bigint not null auto_increment primary key,
    chip_wl_rank_id bigint not null comment '芯片波段ID',
    model_bom_id  bigint not null comment 't_model_bom 表的ID'
)comment '生产搭配对应的芯片波段';


create table t_model_formula
(
    id             bigint  not null auto_increment primary key,
    model_bom_id   bigint  not null comment '配方id',
    material_id    bigint  not null comment 'a胶，b胶，荧光粉、抗成淀粉、扩散粉 a胶和b胶对应的胶水详情表',
    ratio          double  not null comment '比值',
    material_class tinyint not null comment '物料类型 0胶A，1胶水B,2 荧光粉，3 抗沉淀粉，4 扩散粉',
    constraint fk_formula_id foreign key (model_bom_id) references t_model_bom (id)
) comment ='配比详细信息（配比库）';




create table bs_formula_update_log
(
    id           bigint   not null auto_increment primary key,
    model_bom_id bigint   not null comment '配方id',
    update_type  tinyint  not null default 2 comment '1系统推荐，2用户编辑，3生产修正',
    creator      bigint comment '修改用户',
    create_time  datetime not null default now() comment '创建时间',
    constraint fk_formula_update_log_id foreign key (model_bom_id) references t_model_bom (id)
) comment ='配比库更新日志';


-- 修改外键和新加
create table bs_formula_update_log_dtl
(
    id                    bigint   not null auto_increment primary key,
    formula_update_log_id bigint   not null comment '配比修改日志',
    model_bom_id          bigint   not null comment '配方id - 新加',
    material_id           bigint   not null comment 'a胶，b胶，荧光粉、抗成淀粉、扩散粉 a胶和b胶对应的胶水详情表 - 新加',
    ratio                 double   not null comment '比值 - 新加',
    material_class        tinyint  not null comment '物料类型 0胶A，1胶水B,2 荧光粉，3 抗沉淀粉，4 扩散粉 - 新加',
    create_time           datetime not null default now() comment '创建时间',
    constraint fk_formula_update_log_dtl_id foreign key (formula_update_log_id) references bs_formula_update_log (id)
) comment ='系统配比修改所有数据记录,具体存储放内容需和算法联系';



create table bs_formula_update_log_target_parameter
( id   bigint not null auto_increment primary key,
  ra_target    DOUBLE comment '显色指数,目标值/ra系列',
  ra_max       DOUBLE comment '限制范围上限，用于算法显指良率统计',
  ra_min       DOUBLE comment '显色指数下限，用于算法显指良率统计',
  r9           double comment 'R9',
  ct           int comment '色温(k)',
  lumen_lsl    double comment '流明下限',
  lumen_usl    double comment '流明上限',
  wl_lsl       double comment '波长下限',
  wl_usl       double comment '波长上限',
  bs_formula_update_log_id bigint comment '日志表的ID'
) comment ='配比库更新日志表-此配比任何方式新建时的目标参数';



-- ---------------------------------------------------------------------------------------------------------------------
-- EAS工单数据存放表

create table t_feed_exception_reason
(
    id          bigint      not null auto_increment primary key,
    reason      varchar(64) not null,
    flag        tinyint     not null,
    create_time datetime    not null default now() comment '同步创建时间'
) comment '投单异常原因定义';


create table eas_wo
(
    id                bigint   not null auto_increment primary key,
    eas_billId        varchar(64) comment '生产订单ID',
    eas_billNumber    varchar(64) comment '生产订单编码',
    eas_bizDate       varchar(64) comment '业务日期',
    eas_status        varchar(64) comment '状态',
    eas_storageId     varchar(64) comment '库存组织ID',
    eas_storageNumber varchar(64) comment '库存组织编码',
    eas_storageName   varchar(64) comment '库存组织名称',
    eas_adminOrgId    varchar(64) comment '部门ID',
    eas_adminOrgNumber varchar(64) comment '部门编码',
    eas_adminOrgName   varchar(64) comment '部门名称',
    eas_productId      varchar(64) comment '产品ID',
    eas_productNumber  varchar(64) comment '产品编码',
    eas_productName   varchar(64) comment '产品名称',
    eas_productModel  varchar(64) comment '产品规格型号',
    eas_ttypeNumber   varchar(64) comment '事务类型编码',
    eas_ttypeName     varchar(64) comment '事务类型名称',
    eas_bomNumber     varchar(64) comment 'Bom编码',
    eas_qty           numeric comment '订单数量',
    eas_inWarehQty    numeric comment '订单已入库数量',
    eas_planBeginDate varchar(64) comment '计划开工日期',
    eas_planEndDate   varchar(64) comment '计划完工日期',
    eas_remak         varchar(256) comment 'eas 工单备注',
    feed_exception    varchar(64) comment '投料是否异常,存放异常原因，如果为null没有异常，可以投产,不为null,有异常',
    conver_type       tinyint  not null default 0 comment '是否已处理,当被成功转为我们系统的工单时，修改该状态 0 未投产 1 投产成功 ',
    group_id          bigint not null comment '组织机构ID,用来确定这条工单属于哪个生产车间',
    create_time       datetime not null default now() comment '同步创建时间',
    convert_time      datetime comment '投产时间',
    constraint f_eas_wo_group_id foreign key (group_id) references t_group (id)
) comment '从木林森EAS同步的工单，需要用户手动转为我们系统的工单';

create table eas_wo_dtl
(
    id             bigint not null auto_increment primary key,
    wo_id          bigint null comment 'eas_wo 表id',
    entryId        varchar(64) comment '分录ID',
    parentId       varchar(64) comment '生产订单ID',
    materialId     varchar(64) comment '生产订单ID',
    materialNumber varchar(64) comment '物料编码',
    materialName   varchar(64) comment '物料名称',
    materialModel  varchar(64) comment '规格型号',
    unitName       varchar(64) comment '计量单位',
    standardQty    numeric comment '标准用量',
    reqQty         numeric comment '需求数量',
    unitQty        numeric comment '单位用量',
    issueQty       numeric comment '已领料数量',
    returnQty      numeric comment '退料数量',
    material_class tinyint comment '物料类型，null 未知,0芯片  1胶水 2 荧光粉 3 支架 4扩散粉 5抗沉淀粉',
    canIssueQty    numeric comment '可领料数量',
    constraint fk_eas_wo_id foreign key (wo_id) references eas_wo (id)
) comment '从木林森EAS同步的工单，需要用户手动转为我们系统的工单';


-- ---------------------------------------------------------------------------------------------------------------------
-- 业务流程库

-- 任务单
create table bs_task
(
    id          bigint      not null auto_increment primary key,
    task_code   varchar(32) not null comment '工单编码',
    type        tinyint              default 0 comment '工单类型，0量产单 1 样品单',
    wo_id       bigint comment '来自EAS_wo的那条记录',
    state       bool                 default false comment '工单是否关闭,ture关闭，false未关闭',
    create_time datetime    not null default now() comment '创建时间',
    close_time  datetime comment '关闭时间',
    rar9Type    tinyint       default 1 comment '0 忽略 1不忽略',
    constraint f_eas_wo_id foreign key (wo_id) references eas_wo (id)
) comment ='生产任务单';

# create table t_reason_class
# (
#     id          bigint      not null auto_increment primary key,
#     name        varchar(64) not null comment '原因类别名',
#     create_time datetime    not null default now() comment '创建时间'
# ) comment ='状态变更原因分类';
#
# create table t_reason
# (
#     id              bigint      not null auto_increment primary key,
#     reason_class_id bigint      not null comment '原因类别',
#     name            varchar(64) not null comment '原因名',
#     create_time     datetime    not null default now() comment '创建时间',
#     constraint fk_reason_class_id foreign key (reason_class_id) references t_reason_class (id)
# ) comment ='状态变更原因';

-- 工单状态
create table t_task_state_df
(
    id          bigint      not null auto_increment primary key,
    state_name  varchar(32) not null comment '状态内容',
    state_flag  tinyint     not null comment '状态编号',
    create_time datetime    not null default now() comment '创建时间'
) comment ='任务单状态定义';

-- 阀体设备状态
create table t_eqpt_valve_state_df
(
    id          bigint      not null auto_increment primary key,
    state_name  varchar(32) not null comment '设备阀体状体',
    state_flag  tinyint     not null comment '状态编号',
    create_time datetime    not null default now() comment '创建时间'
) comment ='阀体设备状态定义';


create table bs_task_state
(
    id                                 bigint   not null auto_increment primary key,
    task_id                            bigint   not null comment '任务单id',
    task_df_id                         bigint   not null comment '任务状态定义id',
    is_retest                          bool not null DEFAULT false comment '是否重新测试',
    model_id                           bigint   not null comment '当前状态对应的算法模型',
    reason                             varchar(256) comment '失败原因',
    solution_type                      tinyint comment '解决措施 成功为0, 1忽略继续生产  2修改点胶量 3修改配比 4 修改bom 5 前测数据批量否定',
    create_time                        datetime not null default now() comment '创建时间',
    modify_time                        datetime comment '修改时间',
    is_active                          bool     not null default true comment '当前是否处于活动状态',
    creator                            bigint   not null comment '当前登录用户',
    update_user                        bigint   comment '修改状态的用户',
    check_user                         bigint comment '状态变更修改确认用户',
    output_require_before_test_rule_id bigint comment '前测规则ID',
    output_require_nbake_rule_id       bigint comment '非正常烤',
    fileid_list                        varchar(2000) comment '文件id的list',
    constraint fk_task_state_df_id foreign key (task_df_id) references t_task_state_df (id),
    constraint fk_output_require_before_test_rule_id foreign key (output_require_before_test_rule_id) references t_output_require_before_test_rule (id),
    constraint fk_output_require_nbake_rule_id foreign key (output_require_nbake_rule_id) references t_output_require_nbake_rule (id),
    constraint fk_task_state_model_id foreign key (model_id) references t_ai_model (id),
    constraint fk_task_state_id foreign key (task_id) references bs_task (id)
) comment ='任务单状态';


create table bs_eqpt_valve_state
(
    id               bigint   not null auto_increment primary key,
    task_state_id    bigint   not null comment '任务状体id',
    eqpt_valve_id    bigint   not null comment '设备阀体id',
    eqpt_valve_df_id bigint   not null comment '设备阀体状态定义',
    create_time      datetime not null default now() comment '创建时间',
    constraint fk_eqpt_valve_state_valve_id foreign key (eqpt_valve_id) references t_eqpt_valve (id),
    constraint fk_eqpt_valve_df_valve_id foreign key (eqpt_valve_df_id) references t_eqpt_valve_state_df (id),
    constraint fk_eqpt_valve_task_state_id foreign key (task_state_id) references bs_task_state (id)
) comment '设备状态阀体';

create table bs_task_formula
(
    id            bigint not null auto_increment primary key,
    task_state_id bigint not null comment '任务单状态 id',
    task_bom_id   bigint not null comment '任务单状态bom id,取当前任务单状态对应的model bom id',
    /*vesion_code   int    not null comment '配比的版本号,不断累加',
    vesion_time   datetime not null comment '配比的创建时间',*/
    constraint fk_task_formula_info_id foreign key (task_state_id) references bs_task_state (id)
) comment ='任务在每个阶段的配比';

create table bs_task_formula_dtl
(
    id              bigint  not null auto_increment primary key,
    task_formula_id bigint  not null comment '任务单状态 id',
    material_id     bigint  not null comment 'a胶，b胶，荧光粉、抗成淀粉、扩散粉 a胶和b胶对应的胶水详情表',
    ratio           double  not null comment '比值',
    material_class  tinyint not null comment '物料类型 0胶A，1胶水B,2 荧光粉，3 抗沉淀粉  4 扩散粉  ',
    constraint fk_task_formula_dtl_id foreign key (task_formula_id) references bs_task_formula (id)
) comment ='任务在每个阶段配比详细信息';


-- 设备机台点胶库
create table bs_eqpt_gule_dosage
(
    id            bigint   not null auto_increment primary key,
    task_state_id bigint   not null comment '任务单状态 id',
    eqpt_valve_id bigint   not null comment '设备阀体id',
    dosage        double   not null comment '点胶用量',
    create_time   datetime not null default now() comment '创建时间',
    constraint fk_task_state_dosage foreign key (task_state_id) references bs_task_state (id),
    constraint fk_gule_dosage_eqpt_valve_id foreign key (eqpt_valve_id) references t_eqpt_valve (id)
) comment ='设备机台点胶用量，用于记录此设备的点胶用量,如果每修改一次点胶量，此表增加一条数据';


create table bs_eqpt_task_runtime
(
    id            bigint   not null auto_increment primary key,
    task_id       bigint   not null comment '任务单id',
    eqpt_valve_id bigint   not null comment '设备阀体id',
    create_time   datetime not null default now() comment '创建时间',
    constraint fk_eqpt_task_id foreign key (task_id) references bs_task (id),
    constraint fk_task_eqpt_valve_id foreign key (eqpt_valve_id) references t_eqpt_valve (id)
) comment ='设备任务状态，当前设备正在做那个任务单,当该设备完成当前任务单点胶时，将删除相应记录';

-- ---------------------------------------------------------------------------------------------------------------------
-- 分光结果
create table d_upload_file
(
    id            bigint       not null auto_increment primary key,
    task_state_id bigint       not null comment '任务单状态 id',
    path          varchar(512) not null comment '文件路径',
    classType     tinyint      not null comment '文件类型,0 正常烤文件 1 非正常烤文件 2 前测文件',
    process_type  tinyint      not null default 0 comment '工艺类型，0 单层工艺，1 双层工艺',
    gule_layer    tinyint               default 0 comment '只针对双层工艺，双层工艺先下后上，层级 0 下层 1 上层; ',
    user_id       bigint       not null comment '关联用户表，上传当前文件的用户',
    device_ip     varchar(64) comment '测试机ip',
    device_code   varchar(32) comment '测试及编号',
    eqpt_valve_id bigint       not null comment '生产设备阀体id',
    digest        varchar(64) comment '文件摘要,取文件的md5，防止文件被篡改',
    create_time   datetime     not null default now() comment '创建时间',
    is_delete     bool         not null default false comment '文件是否废弃,false不废弃，true废弃',
    file_state    tinyint      not null default -1 comment '文件状态，-1未判定，0判定ok,1判定NG',
    judgeUser     bigint       comment'判定人',
    judgeTime     datetime     comment '判定时间',
    constraint fk_task_state_file foreign key (task_state_id) references bs_task_state (id)
) comment ='分光文件,每次上上传的分光文件';

-- 分光文件判定结果表
create table d_upload_file_judgement_result(
    id            bigint       not null auto_increment primary key,
    file_id       bigint not null comment '分光文件id',
    color_coordinates int     default  null comment '色坐标判定结果 ,0 OK，1 NG ',
    lightness       int       default  null comment '亮度判定结果,0 OK，1 NG',
    ra              int       default  null comment 'ra的判定结果,0 OK，1 NG',
    r9              int       default  null comment 'r9的判定结果,0 OK，1 NG'
)comment ='分光文件,分光文件判定结果表';


create table d_file_color_region_summary
(
    id                  bigint auto_increment primary key,
    file_id             bigint not null comment '分光文件id',
    color_region_id     bigint  comment '色区id',
    color_region_dtl_id bigint  comment '色区详情id',
    total_size          bigint null comment '总量',
    bin_size            bigint null comment '各色区落bin数',
    constraint fk_file_color_region_summary_id foreign key (file_id) references d_upload_file (id),
    constraint fk_file_summary_color_region_id foreign key (color_region_id) references t_color_region (id)
  --  constraint fk_file_summary_color_region_dtl_id foreign key (color_region_dtl_id) references t_color_region_dtl (id)
) comment ='分光文件各色取落bin率统计';

--  ！分光结果汇总
create table d_file_summary
(
    id                    bigint not null auto_increment primary key,
    file_id               bigint not null comment '分光文件id',
    total_size            double comment '总量，测试记录数',
    cie_x                 double comment '打靶的中心点x坐标',
    cie_y                 double comment '打靶的中心点y坐标',
    cie_x_std             double comment 'cie_x标准差',
    cie_y_std             double comment 'cie_y标准差',
    cie_xy_corr           double comment 'cie_xy相关系数',
    euclidean_distance_xy double comment '打靶中心点距离目标中心的欧式距离',
    euclidean_distance_x  double comment 'x方向欧式距离',
    euclidean_distance_y  double comment 'y方向欧式距离',
    ra_mean               double comment '显指均值',
    ra_media              double comment '显指中位数',
    ra_max                double comment '显指最大值',
    ra_min                double comment '显指最小值',
    ra_std                double comment '显指标准差',
    ra_yield              double comment '显示指数良率',
    cri9_mean             double comment 'cri9均值',
    cri9_media            double comment 'cri9中位数',
    cri9_max              double comment 'cri9最大值',
    cri9_min              double comment 'cri9最小值',
    cri9_std              double comment 'cri9标准差',
    lm_mean               double comment 'lm均值',
    lm_media              double comment 'lm中位数',
    lm_max                double comment 'lm最大值',
    lm_min                double comment 'lm最小值',
    lm_std                double comment 'lm标准差',

    -- 2020版新增字段
    ra_describe   varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '显指分位数统计',
    cri9_describe varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'cri9分位数统计',
    lm_describe   varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'lm分位数统计',

    constraint fk_file_summary_file_id foreign key (file_id) references d_upload_file (id)
) comment ='分光结果汇总';



create table bs_model_factor
(
    id            bigint   not null auto_increment primary key,
    model_id      bigint   not null comment '模型id',
    mcoff_valgol  TEXT     not null comment '基于体积,json格式采用{荧光粉id:系数}',
    mcoff_walgol  TEXT     not null comment '基于质量,json格式采用{荧光粉id:系数}',
    task_state_id bigint   not null comment '关联具体任务单状态',
    is_active     bool comment '标识系数是否该模型最新系数， true 是最新 false 不是',
    modify_time   datetime comment '记录模型系数被修改的时间',
    create_time   datetime not null default now() comment '模型参数创建时间',
    constraint fk_ai_model_factor_task_state_id foreign key (task_state_id) references bs_task_state (id),
    constraint fk_ai_model_factor_id foreign key (model_id) references t_ai_model (id)
) comment '模型系数';

create table bs_model_recommend_result
(
    id              bigint   not null auto_increment primary key,
    model_id        bigint   not null comment '模型id',
    valgol          TEXT     not null comment '基于体积,json格式采用[{荧光粉id:比例}]',
    walgol          TEXT     not null comment '基于质量,json格式采用[{荧光粉id:比例}]',
    model_factor_id bigint   not null comment '模型系数id',
    task_state_id   bigint comment '关联具体任务单状态',
    create_time     datetime not null default now() comment '模型参数创建时间',
    ra_commend_param double(10, 3) NULL DEFAULT NULL COMMENT '显指推荐参数，如0.5',
    constraint fk_ai_model_result_model_factor_id foreign key (model_factor_id) references bs_model_factor (id),
    constraint fk_ai_model_result_factor_id foreign key (model_id) references t_ai_model (id)
) comment '算法每次推荐结果存储';

create table bs_model_data_source
(
    id              bigint   not null auto_increment primary key,
    model_factor_id bigint   not null comment '模型id',
    file_id         bigint   not null comment '分光文件id',
    create_time     datetime not null default now() comment '创建时间',
    constraint fk_ai_model_file_id foreign key (file_id) references d_upload_file (id),
    constraint fk_ai_model_factor_data_source_id foreign key (model_factor_id) references bs_model_factor (id)
) comment '更新当前模型所使用的数据源';

-- ---------------------------------------------------------------------------------------------------------------------
-- 原料库所用编码相关数据规则
create table material_type_map
(
    id           bigint auto_increment primary key,
    materal_type tinyint  not null comment '物料类型，0芯片  1胶水 2 荧光粉 3 支架 4扩散粉 5抗沉淀粉',
    type_name    varchar(64) comment '物料类型名',
    map_rule     varchar(128) comment '物料编码与类型映射规则，建议为正则表达式,通过正则过滤',
    remark       varchar(128) comment '备注',
    disabled     bool     not null default false comment '是否禁用 false 不禁用 true 禁用',
    is_delete    bool     not null default false comment 'false正常、true 删除',
    create_time  datetime not null default now() comment '创建时间'
) comment = '物料编码与类型映射规则，建议为正则表达式';


-- ---------------------------------------------------------------------------------------------------------------------





##查询所有的模型信息  转换成视图
/*CREATE VIEW t_ai_model_dtl AS
SELECT DISTINCT
    t_model_material_info.*,
    t_glue.ratio_a,
    t_glue.ratio_b,
    ifnull( t_diffusion_powder.add_proportion, t_anti_starch.add_proportion ) ratio_anti,
    t_type_machine.ra_target,
    t_output_requirements_dtl.cp_x,
    t_output_requirements_dtl.cp_y
FROM
    (
        SELECT
            t_ai_model.id model_id,
            t_ai_model.type_machine_id,
            t_ai_model.color_region_id,
            t_ai_model.output_require_machine_id,
            t_model_bom.bom_id,
            t_model_bom.chip_wl_rank_id,
            ( t_chip_wl_rank.wl_min + t_chip_wl_rank.wl_max ) / 2 chip_wl_rank,
            GROUP_CONCAT( t_bom_Phosphor.phosphor_id ) phosphor_id_list,
            COUNT( t_bom_Phosphor.phosphor_id ) pcount,
            ( CASE WHEN tb.diffusion_powder_id IS NOT NULL OR tb.anti_starch_id IS NOT NULL THEN 0 ELSE 1 END ) anti_type,
            tb.anti_starch_id,
            tb.diffusion_powder_id,
            tb.scaffold_id,
            tb.chip_id,
            tb.glue_id
        FROM
            t_ai_model
                LEFT JOIN t_model_bom ON t_ai_model.id = t_model_bom.model_id
                LEFT JOIN t_bom tb ON t_model_bom.bom_id = tb.id
                LEFT JOIN t_bom_Phosphor ON t_bom_Phosphor.bom_id = tb.id
                LEFT JOIN t_chip_wl_rank ON t_chip_wl_rank.id = t_model_bom.chip_wl_rank_id
        WHERE
                t_ai_model.is_delete = 0
          AND disabled = 0
        GROUP BY
            t_ai_model.id,
            t_ai_model.color_region_id,
            t_ai_model.output_require_machine_id,
            t_model_bom.chip_wl_rank_id,
            t_model_bom.bom_id,
            tb.scaffold_id,
            tb.chip_id,
            tb.glue_id
    ) t_model_material_info
        LEFT JOIN t_output_requirements_dtl ON t_output_requirements_dtl.output_require_id = t_model_material_info.output_require_machine_id
        LEFT JOIN t_type_machine ON t_type_machine.id = t_model_material_info.type_machine_id
        LEFT JOIN t_glue ON t_glue.id = t_model_material_info.glue_id
        LEFT JOIN t_diffusion_powder ON t_diffusion_powder.id = t_model_material_info.diffusion_powder_id
        LEFT JOIN t_anti_starch ON t_anti_starch.id = t_model_material_info.anti_starch_id;*/



CREATE VIEW t_ai_model_dtl AS
SELECT DISTINCT
    t_model_material_info.*,
    t_glue.ratio_a,
    t_glue.ratio_b,
    ifnull( t_diffusion_powder.add_proportion, t_anti_starch.add_proportion ) ratio_anti,
    t_type_machine.ra_target,
    t_output_requirements_dtl.cp_x,
    t_output_requirements_dtl.cp_y
FROM
(  			SELECT t_ai_model.id                               model_id,
            t_ai_model.type_machine_id,
            t_ai_model.color_region_id,
            t_ai_model.output_require_machine_id,
            t_model_bom.bom_id,
            chip_wl_rank.chip_wl_rank_id as chip_wl_rank_id,
            chip_wl_rank.chip_wl_rank               as chip_wl_rank,
            phosphor.phosphor_id_list               as phosphor_id_list,
            phosphor.pcount as pcount,
            (CASE
                 WHEN tb.diffusion_powder_id IS NOT NULL OR tb.anti_starch_id IS NOT NULL THEN 0
                 ELSE 1 END)                            anti_type,
            tb.anti_starch_id,
            tb.diffusion_powder_id,
            tb.scaffold_id,
            chip.chip_id                       as chip_id,
            tb.glue_id
     FROM t_ai_model
              LEFT JOIN t_model_bom ON t_ai_model.id = t_model_bom.model_id
              LEFT JOIN t_bom tb ON t_model_bom.bom_id = tb.id
              LEFT JOIN (SELECT bom_id,group_concat(phosphor_id ORDER BY phosphor_id) phosphor_id_list,count(*) pcount FROM t_bom_Phosphor group by bom_id) phosphor ON phosphor.bom_id = tb.id
              LEFT JOIN
          (SELECT model_bom_id,group_concat(chip_wl_rank_id ORDER BY chip_wl_rank_id) as chip_wl_rank_id,sum(chip_wl_rank)/count(*) as chip_wl_rank FROM
              (
                  SELECT model_bom_id,chip_wl_rank_id,(t_chip_wl_rank.wl_min + t_chip_wl_rank.wl_max) / 2 chip_wl_rank from t_model_bom_chip_wl_rank
                                                                                                                                LEFT JOIN t_chip_wl_rank ON t_model_bom_chip_wl_rank.chip_wl_rank_id = t_chip_wl_rank.id
              ) a
           group by a.model_bom_id
          ) chip_wl_rank ON chip_wl_rank.model_bom_id = tb.id
              LEFT JOIN (SELECT  bom_id,group_concat(chip_id ORDER BY chip_id) as chip_id FROM t_bom_chip group by bom_id) chip ON chip.bom_id = tb.id
     WHERE t_ai_model.is_delete = 0
       AND disabled = 0
     GROUP BY  t_ai_model.id,
               t_ai_model.color_region_id,
               t_ai_model.output_require_machine_id,
               chip_wl_rank.chip_wl_rank_id,
               t_model_bom.bom_id,
               tb.scaffold_id,
               chip.chip_id,
               tb.glue_id
    ) t_model_material_info
        LEFT JOIN t_output_requirements_dtl ON t_output_requirements_dtl.output_require_id = t_model_material_info.output_require_machine_id
        LEFT JOIN t_type_machine ON t_type_machine.id = t_model_material_info.type_machine_id
        LEFT JOIN t_glue ON t_glue.id = t_model_material_info.glue_id
        LEFT JOIN t_diffusion_powder ON t_diffusion_powder.id = t_model_material_info.diffusion_powder_id
        LEFT JOIN t_anti_starch ON t_anti_starch.id = t_model_material_info.anti_starch_id;



##查询模型下满足要求的task_id，分光文件结果在0.003之间的分光文件
##创建视图 查询模型下的所有工单信息
create view t_model_task_id_dtl as
SELECT
    bs_task_state.model_id,
    bs_task_state.task_id,
    bs_task_state.id task_state_id,
    bs_task_state.create_time task_state_id_create_time,
    bs_task.create_time task_id_create_time,
    bs_task_state.task_df_id,
    d_upload_file.id file_id,
    d_upload_file.create_time file_id_create_time,
    d_upload_file.classType,
    d_file_summary.euclidean_distance_x,
    d_file_summary.euclidean_distance_y
FROM
    bs_task
        LEFT JOIN bs_task_state ON bs_task_state.task_id = bs_task.id
        JOIN d_upload_file ON bs_task_state.id = d_upload_file.task_state_id
        LEFT JOIN d_file_summary ON d_upload_file.id = d_file_summary.file_id
WHERE
        d_upload_file.is_delete = 0
  AND bs_task_state.is_retest = FALSE
  AND d_file_summary.euclidean_distance_x <= 0.003
  AND d_file_summary.euclidean_distance_y <= 0.003 AND d_file_summary.total_size > 100
  AND bs_task_state.task_df_id NOT IN ( 1, 3, 5 );


-- 2.0新增视图
create view bom_view as
SELECT
    bom.bom_id AS bom_id,
    bom.scaffold_id AS scaffold_id,
    bom.glue_id AS glue_id,
    bom.anti_starch_id AS anti_starch_id,
    bom.diffusion_powder_id AS diffusion_powder_id,
    bom.chip_count AS chip_count,
    bom.chip_list AS chip_list,
    count( c.phosphor_id ) AS phosphor_count,
    group_concat( c.phosphor_id SEPARATOR ',' ) AS phosphor_list
FROM
    (
     (
         (
             SELECT
                 a.id AS bom_id,
                 a.scaffold_id AS scaffold_id,
                 a.glue_id AS glue_id,
                 a.anti_starch_id AS anti_starch_id,
                 a.diffusion_powder_id AS diffusion_powder_id,
                 count( b.chip_id ) AS chip_count,
                 group_concat( b.chip_id SEPARATOR ',' ) AS chip_list
             FROM
                 (t_bom a LEFT JOIN t_bom_chip b ON ( ( a.id = b.bom_id ) ) )
             GROUP BY
                 a.id
         )
     ) bom
        LEFT JOIN t_bom_Phosphor c ON ( ( bom.bom_id = c.bom_id ) )
        )
GROUP BY
    bom.bom_id;
















