package com.example.demo.app;

import com.example.demo.common.ApiResponse;
import com.example.demo.app.vo.AppVO;
import com.example.demo.app.entity.AppEntity;
import com.example.demo.app.mapper.AppMapper;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/apps")
public class AppController {
    private final AppMapper appMapper;

    public AppController(AppMapper appMapper) {
        this.appMapper = appMapper;
    }

    // 新：支持排序 + 分页
    @GetMapping
    public ApiResponse<PageResult<AppVO>> list(
            @RequestParam(defaultValue = "rating") String sort,
            @RequestParam(defaultValue = "desc") String order,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size) {

        // 排序字段白名单（与 XML 的 choose 对齐）
        Set<String> allowedSorts = Set.of("rating", "downloads", "published_at", "id");
        if (!allowedSorts.contains(sort)) sort = "id";
        order = "asc".equalsIgnoreCase(order) ? "asc" : "desc";

        int p = Math.max(page, 1);
        int s = Math.max(size, 1);
        int offset = (p - 1) * s;

        List<AppEntity> entities = appMapper.findPageSorted(sort, order, offset, s);
        long total = appMapper.countAll();

        List<AppVO> items = new ArrayList<>(entities.size());
        for (AppEntity e : entities) {
            AppVO vo = AppVO.builder()
                    .id(e.getId())
                    .name(e.getName())
                    .description(e.getDescription())
                    .fullDescription(e.getFullDescription())
                    .avatar(e.getAvatar())
                    .category(e.getCategory())
                    .price(e.getPrice())
                    .rating(e.getRating())
                    .downloads(e.getDownloads())
                    .reviews(e.getReviews())
                    .author(e.getAuthor())
                    .publishedAt(e.getPublishedAt())
                    .build();
            items.add(vo);
        }

        return ApiResponse.ok(new PageResult<>(items, total, p, s, sort, order));
    }


    // 根据分类查询应用
    @GetMapping("/category/{category}")
    public ApiResponse<List<AppVO>> listByCategory(@PathVariable String category) {
        List<AppEntity> entities = appMapper.findByCategory(category);
        List<AppVO> out = new ArrayList<>();
        for (AppEntity e : entities) {
            AppVO vo = AppVO.builder()
                    .id(e.getId())
                    .name(e.getName())
                    .description(e.getDescription())
                    .fullDescription(e.getFullDescription())
                    .avatar(e.getAvatar())
                    .category(e.getCategory())
                    .price(e.getPrice())
                    .rating(e.getRating())
                    .downloads(e.getDownloads())
                    .reviews(e.getReviews())
                    .author(e.getAuthor())
                    .publishedAt(e.getPublishedAt())
                    .build();
            out.add(vo);
        }
        return ApiResponse.ok(out);
    }

    public record PageResult<T>(
            List<T> items,
            long total,
            int page,
            int size,
            String sort,
            String order
    ) {}
}