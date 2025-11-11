package com.example.demo.app.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import java.util.List;

// 返回给前端的菜单DTO，包含子菜单
@JsonInclude(JsonInclude.Include.NON_EMPTY) // 如果children为空，则不返回该字段
public class MenuDto {
    private Long id;
    private String name;
    private String path;
    private String icon;
    private List<MenuDto> children;
    private String component;
    // --- Getters and Setters ---
    // (请自行生成所有字段的 Getter 和 Setter)

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public List<MenuDto> getChildren() {
        return children;
    }

    public void setChildren(List<MenuDto> children) {
        this.children = children;
    }

    public String getComponent() {
        return component;
    }

    public void setComponent(String component) {
        this.component = component;
    }
}
