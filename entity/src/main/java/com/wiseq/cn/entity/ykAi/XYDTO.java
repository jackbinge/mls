package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.Objects;


/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/1/7     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class XYDTO implements Comparable{


    private Double x;



    private Double y;


    public XYDTO(Double x, Double y) {
        this.x = x;
        this.y = y;
    }

    public XYDTO() {
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        XYDTO xydto = (XYDTO) o;
        return x.equals( xydto.x) && y.equals(xydto.y);
    }

    @Override
    public int hashCode() {
       /* int result = 17;
        result = 31 * result + (x == null ? 0 : x.hashCode());
        result = 31 * result + (y == null ? 0 : y.hashCode());
        return result;*/
       return Objects.hash(getX(),getY());
    }

    @Override
    public String toString() {
        return "XYDTO{" +
                "x=" + x +
                ", y=" + y +
                '}';
    }

   public int compareTo(Object o) {
        XYDTO xydto = (XYDTO)o;
        return  this.hashCode() - o.hashCode();
    }
}
