package com.wiseq.cn.enums;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        liuchao     原始版本
 * 文件说明: Aoi数据导出配置
 */
public enum AoiEnum {
    STATUS("status", "状态"),
    WAFER_NO("waferNo", "片号"),
    PRODUCTS("products", "产品代码"),
    MACHINE_ID("machineId", "机台编号"),
    INSP_START_TIME("inspStartTime", "检测开始时间"),
    INSP_END_TIME("inspEndTime", "检测结束时间"),
    AOI_TOTAL_DIES("aoiTotalDies", "AOI扫描总颗粒"),
    AOI_OK_DIES("aoiOkDies", "AOI扫描OK颗粒"),
    AOI_NG_DIES("aoiNgDies", "AOI扫描NG颗粒"),
    NO_AOI_OK_DIES("noAoiOkDies", "AOI扫描OK颗粒(去除点测NG)"),
    NO_AOI_NG_DIES("noAoiNgDies", "AOI扫描NG颗粒(去除点测NG)"),
    NO_AOI_YIELD("noAoiYield", "AOI扫描OK颗粒(去除点测NG)/点测OK颗粒"),
    PROBE_TEST_YIELD("probeTestYield", "点测良率"),
    PROBE_TOTAL_DIES("probeTotalDies", "点测总颗粒"),
    PROBE_OK_DIES("probeOkDies", "点测OK颗粒数"),
    PROBE_NG_DIES("probeNgDies", "点测NG颗数"),
    AOI_YIELD_PROBE("aoiYieldProbe", "AOI扫描OK颗粒/点测总颗粒数"),
    AOI_WAFER_YIELD("aoiWaferYield", "AOI扫描OK颗粒/AOI总颗粒数"),
    NONE_PROBE_PERCENTAGE("noneProbePercentage", "AOI定位不良率"),
    COMBINE_WAFER_YIELD("combineWafeYield", "整合良率{AOIOK颗粒数（去除电性NG）/点测总颗粒}"),
    DOUBLE_DIES("doubleDies", "双胞"),
    DOUBLE_DIES_YIELD("doubleDiesYield", "双胞不良率"),
    CRACK_DIES("crackDies", "切割不良等严重瑕疵"),
    CRACK_DIES_YIELD("crackDiesYield", "切割不良等严重瑕疵不良率"),
    REGION_1_DEFECT("region1Defect", "第一区（切割道）"),
    REGION_1_DEFECT_YIELD("region1DefectYield", "第一区（切割道）不良率"),
    REGION_2_DEFECT("region2Defect", "第二区（P电极）"),
    REGION_2_DEFECT_YIELD("region2DefectYield", "第二区（P电极）不良率"),
    REGION_3_DEFECT("region3Defect", "第三区（N电极）"),
    REGION_3_DEFECT_YIELD("region3DefectYield", "第三区（N电极）不良率"),
    REGION_4_DEFECT("region4Defect", "第四区（发光区）"),
    REGION_4_DEFECT_YIELD("region4DefectYield", "第四区（发光区）不良率"),
    REGION_5_DEFECT("region5Defect", "第五区（Finger）"),
    REGION_5_DEFECT_YIELD("region5DefectYield", "第五区（Finger）不良率"),
    REGION_6_DEFECT("region6Defect", "第六区（Measa）"),
    REGION_6_DEFECT_YIELD("region6DefectYield", "第六区（Measa）不良率"),
    REGION_7_DEFECT("region7Defect", "第七区（P电极外圈）"),
    REGION_7_DEFECT_YIELD("region7DefectYield", "第七区（P电极外圈）不良率");

    private String en;
    private String cn;

    AoiEnum(String en, String cn) {
        this.cn = cn;
        this.en = en;
    }

    /**
     * 获取范围值
     *
     * @param en 主键
     * @return
     */
    public static String getStatus(String en) {
        for (AoiEnum state : values()) {
            if (state.en.equals(en)) {
                return state.cn;
            }
        }
        return null;
    }
}
