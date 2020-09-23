package com.wiseq.cn.zuulegate.license;

import de.schlichtherle.license.LicenseManager;
import de.schlichtherle.license.LicenseParam;

class LicenseManagerHolder {

    private static volatile LicenseManager LICENSE_MANAGER;

    static LicenseManager getInstance(LicenseParam param){
        if(LICENSE_MANAGER == null){
            synchronized (LicenseManagerHolder.class){
                if(LICENSE_MANAGER == null){
                    LICENSE_MANAGER = new CustomLicenseManager(param);
                }
            }
        }

        return LICENSE_MANAGER;
    }

}