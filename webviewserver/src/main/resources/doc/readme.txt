
2018-09-28
目标：搭建用于今后实际开发的基本的公共平台，以后就再这个项目代码上逐步增加业务。

一、实现内容：
      1、实现 apitoken的 add,update,delete,list（分页);
      2、实现device的add,update,delete,list（分页::search:fatory/code)/detail;
      search: code name factory
      detail: id/code
      3、实现factory的add,update,delete,list(2级） code：一级格式001,002,二级001001,001002，code/3 就是当前节点的级别;
       search: code name
       detail: id/code
      4、实现department的add,update,delete,list(无限级）code原则同上；
       detail: id/code/
       list: parent_code
      5、实现station的add,update,delete,list;
        detail:id
      6、实现user_role组的add,update,delete,list;
        detail:id
      7、实现user的add,update,delete,list（分页),detail
      user->department,station,user_role关联，并且1VS多方式；
      8、实现Errormsg的add,delete,list(分页）,detail,clear（清理2个月以前的）;
        search: servicename,source,code,create_time时间段 （从xxxx到xxx)

      9、实现根据userid/username 查出用户List<departmentid/user_role/station>/factoryid

      10、loginInfo==>e4444ntity

二、基本要求
      1、使用Spring cloud微服务的方式实现；
      2、数据库采用160上的quanshisoft;
      3、开发涉及12个表的公共模块；
      4、注意和注释公共方法提取，大段代码合理封装成function，避免写成一坨的情况出现;
      5、类名：首字母大写，目录名小写，变量首字母小写，方法首字母小写；
      6、数据表字段采用驼峰命名法，Entity注意转换(mybatis) Ex:create_time ==>createTime；
      7、主要采用enum的方式 NETWORKER_EXCEPTION(2001,"网络异常") throw new QuException(ResultEnum.NETWORKER_EXCEPTION);
      8、Service中可以向外throw RuntimeException,便于事务处理；
      9、前端js采用面向对象方式实现，类似 java的方式 package->class-->method、function；
      10、文件统一采用utf-8方式；
      11、webviewserver中引入thymeleaf,采用thymeleaf可以实现html和java代码的分离，若是引用第三方，在无法实现前后端通过view.js
      实现分离的情况下可以采用thymeleaf,例如baidu editor;
      12、前端采用vue.js（版本2.5）。

三、其他说明：
    1、webviewserver暂时不要搞负载均衡(Session)
    2、所有无状态的内容存到E:\softcode\webapplication\对应的目录中
    3、所有的程序打成jar，不用war包；
    4、实现过程中要对dao/serviceimpl/service/servicefallback编写junit测试（Assert)；
    5、部分jar采用maven方式引入，方法如下：
    mvn install:install-file -DgroupId=com.wiseq.cn.commons -DartifactId=commons -Dversion=0.0.1 -Dfile=E:\softcode\quanshisoft\commons\target\commons-0.0.1.jar -Dpackaging=jar
    mvn install:install-file -DgroupId=com.wiseq.cn.entity -DartifactId=entity -Dversion=0.0.1 -Dfile=E:\softcode\quanshisoft\entity\target\entity-0.0.1.jar -Dpackaging=jar
    6、权限暂时不和模块关联；
    7、dao、service interface设计不要过度。