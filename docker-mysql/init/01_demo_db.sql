-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- 主机： mysql:3306
-- 生成日期： 2026-01-06 15:45:19
-- 服务器版本： 8.0.43
-- PHP 版本： 8.2.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `demo_db`
--

-- --------------------------------------------------------

--
-- 表的结构 `chat_message`
--

CREATE TABLE `chat_message` (
  `id` bigint NOT NULL COMMENT '消息ID',
  `session_id` bigint NOT NULL COMMENT '会话ID',
  `user_id` bigint NOT NULL COMMENT '用户ID（便于审计）',
  `role` varchar(20) NOT NULL COMMENT '角色：user/assistant',
  `content` longtext NOT NULL COMMENT '消息内容',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='聊天消息表';

--
-- 转存表中的数据 `chat_message`
--

INSERT INTO `chat_message` (`id`, `session_id`, `user_id`, `role`, `content`, `created_at`) VALUES
(7, 2, 7, 'user', '你好', '2025-12-27 15:09:28'),
(8, 2, 7, 'assistant', '你好！很高兴见到你。有什么我可以帮助你的吗？\n</think>\n\n你好！很高兴见到你。有什么我可以帮助你的吗？', '2025-12-27 15:09:29'),
(9, 2, 7, 'user', '你好', '2025-12-27 15:13:53'),
(10, 2, 7, 'assistant', '好的，我现在要分析一下用户和我的对话历史。用户一开始打了一个“你好”，然后我回复了“你好！很高兴见到你。有什么我可以帮助你的吗？”。接着用户又回复了“你好”。看起来用户可能是在测试我的反应，或者只是想确认我没有理解错误。\n\n首先，我需要确定用户的主要意图是什么。用户两次说“你好”，可能是在打招呼，或者只是想看看我的反应。也有可能用户是在尝试与我建立联系，或者在进行某种测试。考虑到之前的对话中用户并没有提出具体的问题，所以我需要回应得友好一些，同时保持专业性。\n\n接下来，我应该考虑如何回应用户。用户再次发送“你好”，我应该回应得简洁明了，同时表达出愿意帮助的态度。或许可以询问用户需要什么帮助，这样可以引导用户提供更多信息，从而更好地满足他们的需求。\n\n另外，我还需要注意语气和用词，确保回复自然亲切，让用户感觉这是我自然的回应，而不是机械的程序。使用“很高兴见到你”这样的表达，可以增强互动的感觉，让用户感到被重视。\n\n最后，我应该保持开放的沟通，让用户清楚地知道我随时准备帮助他们，无论是问题解答还是聊天交流。这样用户会感到放心，愿意进一步交流。\n</think>\n\n你好！很高兴见到你。有什么我可以帮助你的吗？', '2025-12-27 15:13:56'),
(11, 2, 7, 'user', '你好', '2025-12-27 15:14:56'),
(12, 2, 7, 'assistant', '好，用户连续发送了“你好”三次，看来对我的回复比较满意。我需要理解用户的需求，可能他们是在测试我的反应，或者是在等待进一步的对话内容。根据之前的对话，用户已经询问过如何帮助他们，所以我应该继续引导他们提供更多信息。确保回应友好，鼓励他们提出具体的问题或任务，这样我才能更好地协助他们。\n</think>\n\n你好！有什么我可以帮助你的吗？', '2025-12-27 15:14:57');

-- --------------------------------------------------------

--
-- 表的结构 `chat_session`
--

CREATE TABLE `chat_session` (
  `id` bigint NOT NULL COMMENT '会话ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `title` varchar(255) DEFAULT NULL COMMENT '会话标题',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间（软删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='聊天会话表';

--
-- 转存表中的数据 `chat_session`
--

INSERT INTO `chat_session` (`id`, `user_id`, `title`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 7, '新会话', '2025-12-27 15:00:39', '2025-12-27 15:09:38', '2025-12-27 15:09:38'),
(2, 7, '新会话', '2025-12-27 15:09:24', '2025-12-27 15:14:57', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `menus`
--

CREATE TABLE `menus` (
  `id` bigint NOT NULL COMMENT '菜单ID',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID, 0表示顶级菜单',
  `name` varchar(255) NOT NULL COMMENT '菜单名称 (例如: 用户管理)',
  `path` varchar(255) DEFAULT NULL COMMENT '前端路由路径 (例如: /user)',
  `component` varchar(255) DEFAULT NULL COMMENT '前端组件路径 (例如: /user/index)',
  `icon` varchar(255) DEFAULT NULL COMMENT '菜单图标',
  `sort_order` int DEFAULT '0' COMMENT '排序顺序',
  `is_visible` tinyint(1) DEFAULT '1' COMMENT '是否可见 (1:是, 0:否)',
  `permission` varchar(255) DEFAULT NULL COMMENT '权限标识 (例如: sys:user:list)',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统菜单表';

--
-- 转存表中的数据 `menus`
--

INSERT INTO `menus` (`id`, `parent_id`, `name`, `path`, `component`, `icon`, `sort_order`, `is_visible`, `permission`, `created_at`, `updated_at`) VALUES
(1, 0, '系统管理', '/system', NULL, 'el-icon-setting', 1, 1, NULL, '2025-11-11 01:58:13', '2025-11-11 01:58:13'),
(2, 0, '仪表盘', '/apps', 'AppsView', 'el-icon-odometer', 0, 1, NULL, '2025-11-11 01:58:13', '2025-11-12 11:40:57'),
(3, 0, '关于', '/about', 'AboutView', 'el-icon-info', 99, 1, NULL, '2025-11-11 01:58:13', '2025-11-11 05:39:08'),
(101, 1, '用户管理', '/system/users', 'system/user/index', NULL, 1, 1, 'sys:user:list', '2025-11-11 01:58:13', '2025-11-11 01:58:13'),
(102, 1, '角色管理', '/system/roles', 'system/role/index', NULL, 2, 1, 'sys:role:list', '2025-11-11 01:58:13', '2025-11-11 01:58:13'),
(103, 1, '菜单管理', '/system/menus', 'system/menu/index', NULL, 3, 1, 'sys:menu:list', '2025-11-11 01:58:13', '2025-11-11 01:58:13');

-- --------------------------------------------------------

--
-- 表的结构 `operation_logs`
--

CREATE TABLE `operation_logs` (
  `id` bigint NOT NULL COMMENT '日志ID',
  `user_id` bigint DEFAULT NULL COMMENT '操作用户ID',
  `operation` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型',
  `resource_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '资源类型',
  `resource_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '资源ID',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '操作描述',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP地址',
  `user_agent` text COLLATE utf8mb4_unicode_ci COMMENT '用户代理',
  `request_data` json DEFAULT NULL COMMENT '请求数据',
  `response_data` json DEFAULT NULL COMMENT '响应数据',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作状态：success, failure, error',
  `error_message` text COLLATE utf8mb4_unicode_ci COMMENT '错误信息',
  `duration` int DEFAULT NULL COMMENT '操作耗时（毫秒）',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';

-- --------------------------------------------------------

--
-- 表的结构 `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint NOT NULL COMMENT '权限ID',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限名称',
  `code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限编码',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '权限描述',
  `module` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '所属模块',
  `resource` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '资源标识',
  `action` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作类型：create, read, update, delete, execute',
  `is_system` tinyint NOT NULL DEFAULT '0' COMMENT '是否系统权限：0-否，1-是',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序顺序',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间（软删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限表';

--
-- 转存表中的数据 `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `code`, `description`, `module`, `resource`, `action`, `is_system`, `status`, `sort_order`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '查看用户列表', 'user:list', '查看系统用户列表', 'user', 'user', 'read', 1, 1, 1, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(2, '创建用户', 'user:create', '创建新用户', 'user', 'user', 'create', 1, 1, 2, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(3, '编辑用户', 'user:update', '编辑用户信息', 'user', 'user', 'update', 1, 1, 3, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(4, '删除用户', 'user:delete', '删除用户', 'user', 'user', 'delete', 1, 1, 4, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(5, '重置用户密码', 'user:reset_password', '重置用户密码', 'user', 'user', 'execute', 1, 1, 5, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(6, '查看角色列表', 'role:list', '查看角色列表', 'role', 'role', 'read', 1, 1, 10, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(7, '创建角色', 'role:create', '创建新角色', 'role', 'role', 'create', 1, 1, 11, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(8, '编辑角色', 'role:update', '编辑角色信息', 'role', 'role', 'update', 1, 1, 12, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(9, '删除角色', 'role:delete', '删除角色', 'role', 'role', 'delete', 1, 1, 13, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(10, '分配角色权限', 'role:assign_permission', '为角色分配权限', 'role', 'role', 'execute', 1, 1, 14, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(11, '查看权限列表', 'permission:list', '查看权限列表', 'permission', 'permission', 'read', 1, 1, 20, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(12, '分配用户角色', 'user:assign_role', '为用户分配角色', 'user', 'user', 'execute', 1, 1, 21, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(13, '查看团队列表', 'team:list', '查看团队列表', 'team', 'team', 'read', 1, 1, 30, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(14, '创建团队', 'team:create', '创建新团队', 'team', 'team', 'create', 1, 1, 31, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(15, '编辑团队', 'team:update', '编辑团队信息', 'team', 'team', 'update', 1, 1, 32, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(16, '删除团队', 'team:delete', '删除团队', 'team', 'team', 'delete', 1, 1, 33, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(17, '管理团队成员', 'team:manage_member', '管理团队成员', 'team', 'team_member', 'execute', 1, 1, 34, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(18, '邀请团队成员', 'team:invite', '邀请用户加入团队', 'team', 'team_invitation', 'create', 1, 1, 35, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(19, '审批加入申请', 'team:approve_request', '审批团队加入申请', 'team', 'team_request', 'execute', 1, 1, 36, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(20, '查看系统配置', 'system:config:read', '查看系统配置', 'system', 'config', 'read', 1, 1, 40, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(21, '修改系统配置', 'system:config:write', '修改系统配置', 'system', 'config', 'update', 1, 1, 41, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(22, '查看操作日志', 'system:log:read', '查看系统操作日志', 'system', 'log', 'read', 1, 1, 42, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL),
(23, '查看登录日志', 'system:login_log:read', '查看用户登录日志', 'system', 'login_log', 'read', 1, 1, 43, '2025-10-29 12:47:05', '2025-10-29 12:47:05', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `roles`
--

CREATE TABLE `roles` (
  `id` bigint NOT NULL COMMENT '角色ID',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色编码',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '角色描述',
  `is_system` tinyint NOT NULL DEFAULT '0' COMMENT '是否系统角色：0-否，1-是（系统角色不可删除）',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序顺序',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间（软删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

--
-- 转存表中的数据 `roles`
--

INSERT INTO `roles` (`id`, `name`, `code`, `description`, `is_system`, `status`, `sort_order`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '超级管理员', 'super_admin', '系统最高权限管理员，拥有所有权限', 1, 1, 1, '2025-10-29 12:46:33', '2025-10-29 12:46:33', NULL),
(2, '系统管理员', 'admin', '系统管理员，可管理用户、角色、团队等', 1, 1, 2, '2025-10-29 12:46:33', '2025-10-29 12:46:33', NULL),
(3, '团队负责人', 'team_owner', '团队创建者和最高管理者', 1, 1, 3, '2025-10-29 12:46:33', '2025-10-29 12:46:33', NULL),
(4, '团队管理员', 'team_admin', '团队管理员，可管理团队成员', 1, 1, 4, '2025-10-29 12:46:33', '2025-10-29 12:46:33', NULL),
(5, '普通用户', 'user', '普通注册用户', 1, 1, 5, '2025-10-29 12:46:33', '2025-10-29 12:46:33', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `role_menus`
--

CREATE TABLE `role_menus` (
  `id` bigint NOT NULL,
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色菜单关联表';

--
-- 转存表中的数据 `role_menus`
--

INSERT INTO `role_menus` (`id`, `role_id`, `menu_id`) VALUES
(1, 2, 1),
(2, 2, 2),
(3, 2, 3),
(4, 2, 101),
(5, 2, 102),
(6, 2, 103),
(7, 5, 2),
(8, 5, 3);

-- --------------------------------------------------------

--
-- 表的结构 `role_permissions`
--

CREATE TABLE `role_permissions` (
  `id` bigint NOT NULL COMMENT '关联ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `permission_id` bigint NOT NULL COMMENT '权限ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色权限关联表';

--
-- 转存表中的数据 `role_permissions`
--

INSERT INTO `role_permissions` (`id`, `role_id`, `permission_id`, `created_at`) VALUES
(1, 1, 1, '2025-10-29 12:47:28'),
(2, 1, 2, '2025-10-29 12:47:28'),
(3, 1, 3, '2025-10-29 12:47:28'),
(4, 1, 4, '2025-10-29 12:47:28'),
(5, 1, 5, '2025-10-29 12:47:28'),
(6, 1, 6, '2025-10-29 12:47:28'),
(7, 1, 7, '2025-10-29 12:47:28'),
(8, 1, 8, '2025-10-29 12:47:28'),
(9, 1, 9, '2025-10-29 12:47:28'),
(10, 1, 10, '2025-10-29 12:47:28'),
(11, 1, 11, '2025-10-29 12:47:28'),
(12, 1, 12, '2025-10-29 12:47:28'),
(13, 1, 13, '2025-10-29 12:47:28'),
(14, 1, 14, '2025-10-29 12:47:28'),
(15, 1, 15, '2025-10-29 12:47:28'),
(16, 1, 16, '2025-10-29 12:47:28'),
(17, 1, 17, '2025-10-29 12:47:28'),
(18, 1, 18, '2025-10-29 12:47:28'),
(19, 1, 19, '2025-10-29 12:47:28'),
(20, 1, 20, '2025-10-29 12:47:28'),
(21, 1, 21, '2025-10-29 12:47:28'),
(22, 1, 22, '2025-10-29 12:47:28'),
(23, 1, 23, '2025-10-29 12:47:28'),
(32, 2, 11, '2025-10-29 12:47:28'),
(33, 2, 10, '2025-10-29 12:47:28'),
(34, 2, 7, '2025-10-29 12:47:28'),
(35, 2, 6, '2025-10-29 12:47:28'),
(36, 2, 8, '2025-10-29 12:47:28'),
(37, 2, 20, '2025-10-29 12:47:28'),
(38, 2, 22, '2025-10-29 12:47:28'),
(39, 2, 23, '2025-10-29 12:47:28'),
(40, 2, 16, '2025-10-29 12:47:28'),
(41, 2, 13, '2025-10-29 12:47:28'),
(42, 2, 17, '2025-10-29 12:47:28'),
(43, 2, 15, '2025-10-29 12:47:28'),
(44, 2, 12, '2025-10-29 12:47:28'),
(45, 2, 2, '2025-10-29 12:47:28'),
(46, 2, 1, '2025-10-29 12:47:28'),
(47, 2, 5, '2025-10-29 12:47:28'),
(48, 2, 3, '2025-10-29 12:47:28'),
(63, 3, 19, '2025-10-29 12:47:28'),
(64, 3, 14, '2025-10-29 12:47:28'),
(65, 3, 16, '2025-10-29 12:47:28'),
(66, 3, 18, '2025-10-29 12:47:28'),
(67, 3, 17, '2025-10-29 12:47:28'),
(68, 3, 15, '2025-10-29 12:47:28'),
(70, 4, 19, '2025-10-29 12:47:28'),
(71, 4, 18, '2025-10-29 12:47:28'),
(72, 4, 17, '2025-10-29 12:47:28'),
(73, 4, 15, '2025-10-29 12:47:28'),
(77, 5, 14, '2025-10-29 12:47:28');

-- --------------------------------------------------------

--
-- 表的结构 `system_configs`
--

CREATE TABLE `system_configs` (
  `id` bigint NOT NULL COMMENT '配置ID',
  `config_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置键',
  `config_value` text COLLATE utf8mb4_unicode_ci COMMENT '配置值',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '配置描述',
  `type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'string' COMMENT '值类型：string, number, boolean, json',
  `is_public` tinyint NOT NULL DEFAULT '0' COMMENT '是否公开：0-否，1-是',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

--
-- 转存表中的数据 `system_configs`
--

INSERT INTO `system_configs` (`id`, `config_key`, `config_value`, `description`, `type`, `is_public`, `created_at`, `updated_at`) VALUES
(1, 'site_name', '用户管理系统', '网站名称', 'string', 1, '2025-10-29 12:47:46', '2025-10-29 12:47:46'),
(2, 'site_description', '基于RBAC的用户管理系统', '网站描述', 'string', 1, '2025-10-29 12:47:46', '2025-10-29 12:47:46'),
(3, 'user_register_enabled', 'true', '是否允许用户注册', 'boolean', 1, '2025-10-29 12:47:46', '2025-10-29 12:47:46'),
(4, 'email_verification_required', 'true', '注册时是否需要邮箱验证', 'boolean', 0, '2025-10-29 12:47:46', '2025-10-29 12:47:46'),
(5, 'login_max_attempts', '5', '登录最大失败次数', 'number', 0, '2025-10-29 12:47:46', '2025-10-29 12:47:46'),
(6, 'login_lock_duration', '30', '登录锁定时长（分钟）', 'number', 0, '2025-10-29 12:47:46', '2025-10-29 12:47:46'),
(7, 'verification_code_expires', '5', '验证码有效期（分钟）', 'number', 0, '2025-10-29 12:47:46', '2025-10-29 12:47:46'),
(8, 'invitation_expires_days', '7', '邀请链接有效期（天）', 'number', 0, '2025-10-29 12:47:46', '2025-10-29 12:47:46'),
(9, 'max_teams_per_user', '10', '每个用户最大创建团队数', 'number', 0, '2025-10-29 12:47:46', '2025-10-29 12:47:46'),
(10, 'default_team_max_members', '50', '团队默认最大成员数', 'number', 0, '2025-10-29 12:47:46', '2025-10-29 12:47:46');

-- --------------------------------------------------------

--
-- 表的结构 `teams`
--

CREATE TABLE `teams` (
  `id` bigint NOT NULL COMMENT '团队ID',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '团队名称',
  `code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '团队编码',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '团队描述',
  `avatar_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '团队头像URL',
  `visibility` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'private' COMMENT '可见性：public-公开，private-私有',
  `join_policy` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'approval' COMMENT '加入策略：open-开放，approval-需审批，invite-仅邀请',
  `max_members` int DEFAULT NULL COMMENT '最大成员数（null表示无限制）',
  `owner_id` bigint NOT NULL COMMENT '团队负责人ID',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-正常，2-已解散',
  `settings` json DEFAULT NULL COMMENT '团队设置（JSON格式）',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间（软删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='团队表';

-- --------------------------------------------------------

--
-- 表的结构 `team_invitations`
--

CREATE TABLE `team_invitations` (
  `id` bigint NOT NULL COMMENT '邀请ID',
  `team_id` bigint NOT NULL COMMENT '团队ID',
  `inviter_id` bigint NOT NULL COMMENT '邀请者ID',
  `invitee_email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '被邀请者邮箱',
  `invitee_user_id` bigint DEFAULT NULL COMMENT '被邀请者用户ID（如果已注册）',
  `invitation_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邀请码',
  `role` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'member' COMMENT '邀请角色',
  `message` text COLLATE utf8mb4_unicode_ci COMMENT '邀请消息',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '状态：pending-待处理，accepted-已接受，rejected-已拒绝，expired-已过期',
  `expires_at` datetime NOT NULL COMMENT '过期时间',
  `responded_at` datetime DEFAULT NULL COMMENT '响应时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='团队邀请表';

-- --------------------------------------------------------

--
-- 表的结构 `team_join_requests`
--

CREATE TABLE `team_join_requests` (
  `id` bigint NOT NULL COMMENT '申请ID',
  `team_id` bigint NOT NULL COMMENT '团队ID',
  `user_id` bigint NOT NULL COMMENT '申请者ID',
  `message` text COLLATE utf8mb4_unicode_ci COMMENT '申请消息',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '状态：pending-待审批，approved-已批准，rejected-已拒绝，cancelled-已取消',
  `reviewed_by` bigint DEFAULT NULL COMMENT '审批者ID',
  `reviewed_at` datetime DEFAULT NULL COMMENT '审批时间',
  `review_message` text COLLATE utf8mb4_unicode_ci COMMENT '审批意见',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='团队加入申请表';

-- --------------------------------------------------------

--
-- 表的结构 `team_members`
--

CREATE TABLE `team_members` (
  `id` bigint NOT NULL COMMENT '成员ID',
  `team_id` bigint NOT NULL COMMENT '团队ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'member' COMMENT '团队角色：owner-负责人，admin-管理员，member-普通成员',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-已移除，1-正常',
  `joined_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  `invited_by` bigint DEFAULT NULL COMMENT '邀请者ID',
  `permissions` json DEFAULT NULL COMMENT '特殊权限设置（JSON格式）',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='团队成员表';

-- --------------------------------------------------------

--
-- 表的结构 `t_app`
--

CREATE TABLE `t_app` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `name` varchar(100) NOT NULL COMMENT '应用名称',
  `description` varchar(255) NOT NULL COMMENT '简短描述',
  `full_description` text COMMENT '详细描述',
  `avatar` varchar(255) DEFAULT NULL COMMENT '应用头像URL',
  `category` varchar(64) DEFAULT NULL COMMENT '应用分类',
  `price` decimal(10,2) DEFAULT '0.00' COMMENT '价格',
  `rating` double DEFAULT NULL COMMENT '评分',
  `downloads` int DEFAULT NULL COMMENT '下载量',
  `reviews` int DEFAULT NULL COMMENT '评论数',
  `author` varchar(100) DEFAULT NULL COMMENT '作者',
  `published_at` date DEFAULT NULL COMMENT '发布日期',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='应用信息表';

--
-- 转存表中的数据 `t_app`
--

INSERT INTO `t_app` (`id`, `name`, `description`, `full_description`, `avatar`, `category`, `price`, `rating`, `downloads`, `reviews`, `author`, `published_at`, `created_at`) VALUES
(1, '智能客服助手', '基于大语言模型的智能客服系统，支持多轮对话和知识库检索', '这是一个功能强大的智能客服系统，能够理解用户意图，提供准确回答。支持多轮对话、知识库检索、情感分析等功能。', 'https://via.placeholder.com/80x80', 'customer-service', 0.00, 4.8, 1200, 156, 'AI团队', '2024-01-15', '2025-09-25 01:00:20'),
(2, '内容创作大师', 'AI驱动的内容生成和优化工具，支持多种文体创作', '专业的内容创作工具，利用AI技术帮助用户快速生成高质量内容。支持文章、广告文案、社交媒体内容等多种文体的创作和优化。', 'https://via.placeholder.com/80x80', 'content-creation', 0.00, 4.9, 980, 123, '创作工坊', '2024-01-10', '2025-09-25 01:00:20');

-- --------------------------------------------------------

--
-- 表的结构 `users`
--

CREATE TABLE `users` (
  `id` bigint NOT NULL COMMENT '用户ID',
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邮箱',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '手机号',
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码哈希值',
  `nickname` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '昵称',
  `avatar_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '头像URL',
  `bio` text COLLATE utf8mb4_unicode_ci COMMENT '个人简介',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '账户状态：0-禁用，1-正常，2-锁定',
  `email_verified` tinyint NOT NULL DEFAULT '0' COMMENT '邮箱是否验证：0-未验证，1-已验证',
  `phone_verified` tinyint NOT NULL DEFAULT '0' COMMENT '手机是否验证：0-未验证，1-已验证',
  `login_attempts` int NOT NULL DEFAULT '0' COMMENT '登录失败次数',
  `locked_until` datetime DEFAULT NULL COMMENT '锁定到期时间',
  `last_login_at` datetime DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '最后登录IP',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间（软删除）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

--
-- 转存表中的数据 `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `phone`, `password_hash`, `nickname`, `avatar_url`, `bio`, `status`, `email_verified`, `phone_verified`, `login_attempts`, `locked_until`, `last_login_at`, `last_login_ip`, `created_at`, `updated_at`, `deleted_at`) VALUES
(7, 'john1', 'john1@example.com', '13800138001', '$2a$10$5T5FDqNdlvdOk.18qiDVaeo6YliC02hpXZhDQlblNDk2i3pNpiC0W', 'John', NULL, NULL, 1, 0, 0, 0, NULL, NULL, NULL, '2025-11-11 05:00:19', '2025-11-11 05:00:19', NULL),
(8, 'admin', 'admin@example.com', '13800138000', '$2a$10$m0bMAdZhk9S1YnZZOKgmU.DiC0B1jb06riml1Bdz2kzpzgwFczHDi', 'Admin', NULL, NULL, 1, 0, 0, 0, NULL, NULL, NULL, '2025-11-11 07:50:22', '2025-11-11 07:50:22', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `user_login_logs`
--

CREATE TABLE `user_login_logs` (
  `id` bigint NOT NULL COMMENT '日志ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `login_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录方式：email, username, phone, sms',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录IP地址',
  `user_agent` text COLLATE utf8mb4_unicode_ci COMMENT '用户代理信息',
  `device_info` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '设备信息',
  `location` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '登录地点',
  `status` tinyint NOT NULL COMMENT '登录状态：0-失败，1-成功',
  `failure_reason` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '失败原因',
  `session_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '会话ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '登录时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户登录日志表';

-- --------------------------------------------------------

--
-- 表的结构 `user_roles`
--

CREATE TABLE `user_roles` (
  `id` bigint NOT NULL COMMENT '关联ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `assigned_by` bigint DEFAULT NULL COMMENT '分配者用户ID',
  `assigned_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '分配时间',
  `expires_at` datetime DEFAULT NULL COMMENT '过期时间（可选）',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';

--
-- 转存表中的数据 `user_roles`
--

INSERT INTO `user_roles` (`id`, `user_id`, `role_id`, `assigned_by`, `assigned_at`, `expires_at`, `created_at`) VALUES
(2, 7, 5, NULL, '2025-11-11 05:00:19', NULL, '2025-11-11 05:00:19'),
(3, 8, 1, NULL, '2025-11-11 07:50:22', NULL, '2025-11-11 07:50:22');

-- --------------------------------------------------------

--
-- 表的结构 `user_verification_codes`
--

CREATE TABLE `user_verification_codes` (
  `id` bigint NOT NULL COMMENT '验证码ID',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID（注册时可能为空）',
  `type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '验证码类型：email_register, email_reset, sms_register, sms_reset, sms_login',
  `target` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '目标邮箱或手机号',
  `code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '验证码',
  `used` tinyint NOT NULL DEFAULT '0' COMMENT '是否已使用：0-未使用，1-已使用',
  `expires_at` datetime NOT NULL COMMENT '过期时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户验证码表';

--
-- 转储表的索引
--

--
-- 表的索引 `chat_message`
--
ALTER TABLE `chat_message`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_session_id` (`session_id`);

--
-- 表的索引 `chat_session`
--
ALTER TABLE `chat_session`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_updated_at` (`updated_at`);

--
-- 表的索引 `menus`
--
ALTER TABLE `menus`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `operation_logs`
--
ALTER TABLE `operation_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_operation` (`operation`),
  ADD KEY `idx_resource` (`resource_type`,`resource_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- 表的索引 `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_code` (`code`),
  ADD KEY `idx_module` (`module`),
  ADD KEY `idx_resource_action` (`resource`,`action`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_deleted_at` (`deleted_at`);

--
-- 表的索引 `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_code` (`code`),
  ADD UNIQUE KEY `uk_name` (`name`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_sort_order` (`sort_order`),
  ADD KEY `idx_deleted_at` (`deleted_at`);

--
-- 表的索引 `role_menus`
--
ALTER TABLE `role_menus`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_role_menu` (`role_id`,`menu_id`);

--
-- 表的索引 `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_role_permission` (`role_id`,`permission_id`),
  ADD KEY `idx_role_id` (`role_id`),
  ADD KEY `idx_permission_id` (`permission_id`);

--
-- 表的索引 `system_configs`
--
ALTER TABLE `system_configs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_config_key` (`config_key`),
  ADD KEY `idx_is_public` (`is_public`);

--
-- 表的索引 `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_name` (`name`),
  ADD UNIQUE KEY `uk_code` (`code`),
  ADD KEY `idx_owner_id` (`owner_id`),
  ADD KEY `idx_visibility` (`visibility`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_deleted_at` (`deleted_at`);

--
-- 表的索引 `team_invitations`
--
ALTER TABLE `team_invitations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_invitation_code` (`invitation_code`),
  ADD KEY `idx_team_id` (`team_id`),
  ADD KEY `idx_inviter_id` (`inviter_id`),
  ADD KEY `idx_invitee_email` (`invitee_email`),
  ADD KEY `idx_invitee_user_id` (`invitee_user_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_expires_at` (`expires_at`);

--
-- 表的索引 `team_join_requests`
--
ALTER TABLE `team_join_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_team_user_pending` (`team_id`,`user_id`,`status`),
  ADD KEY `idx_team_id` (`team_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_reviewed_by` (`reviewed_by`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- 表的索引 `team_members`
--
ALTER TABLE `team_members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_team_user` (`team_id`,`user_id`),
  ADD KEY `idx_team_id` (`team_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_role` (`role`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_invited_by` (`invited_by`);

--
-- 表的索引 `t_app`
--
ALTER TABLE `t_app`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_username` (`username`),
  ADD UNIQUE KEY `uk_email` (`email`),
  ADD UNIQUE KEY `uk_phone` (`phone`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_deleted_at` (`deleted_at`);

--
-- 表的索引 `user_login_logs`
--
ALTER TABLE `user_login_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_ip_address` (`ip_address`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_status` (`status`);

--
-- 表的索引 `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_user_role` (`user_id`,`role_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_role_id` (`role_id`),
  ADD KEY `idx_assigned_by` (`assigned_by`),
  ADD KEY `idx_expires_at` (`expires_at`);

--
-- 表的索引 `user_verification_codes`
--
ALTER TABLE `user_verification_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_target_type` (`target`,`type`),
  ADD KEY `idx_code` (`code`),
  ADD KEY `idx_expires_at` (`expires_at`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `chat_message`
--
ALTER TABLE `chat_message`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID', AUTO_INCREMENT=13;

--
-- 使用表AUTO_INCREMENT `chat_session`
--
ALTER TABLE `chat_session`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '会话ID', AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `menus`
--
ALTER TABLE `menus`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID', AUTO_INCREMENT=104;

--
-- 使用表AUTO_INCREMENT `operation_logs`
--
ALTER TABLE `operation_logs`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID';

--
-- 使用表AUTO_INCREMENT `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '权限ID', AUTO_INCREMENT=24;

--
-- 使用表AUTO_INCREMENT `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID', AUTO_INCREMENT=6;

--
-- 使用表AUTO_INCREMENT `role_menus`
--
ALTER TABLE `role_menus`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- 使用表AUTO_INCREMENT `role_permissions`
--
ALTER TABLE `role_permissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID', AUTO_INCREMENT=78;

--
-- 使用表AUTO_INCREMENT `system_configs`
--
ALTER TABLE `system_configs`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置ID', AUTO_INCREMENT=11;

--
-- 使用表AUTO_INCREMENT `teams`
--
ALTER TABLE `teams`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '团队ID';

--
-- 使用表AUTO_INCREMENT `team_invitations`
--
ALTER TABLE `team_invitations`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '邀请ID';

--
-- 使用表AUTO_INCREMENT `team_join_requests`
--
ALTER TABLE `team_join_requests`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '申请ID';

--
-- 使用表AUTO_INCREMENT `team_members`
--
ALTER TABLE `team_members`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '成员ID';

--
-- 使用表AUTO_INCREMENT `t_app`
--
ALTER TABLE `t_app`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID', AUTO_INCREMENT=3;

--
-- 使用表AUTO_INCREMENT `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID', AUTO_INCREMENT=14;

--
-- 使用表AUTO_INCREMENT `user_login_logs`
--
ALTER TABLE `user_login_logs`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID';

--
-- 使用表AUTO_INCREMENT `user_roles`
--
ALTER TABLE `user_roles`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID', AUTO_INCREMENT=9;

--
-- 使用表AUTO_INCREMENT `user_verification_codes`
--
ALTER TABLE `user_verification_codes`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT COMMENT '验证码ID';

--
-- 限制导出的表
--

--
-- 限制表 `chat_message`
--
ALTER TABLE `chat_message`
  ADD CONSTRAINT `fk_chat_message_session` FOREIGN KEY (`session_id`) REFERENCES `chat_session` (`id`) ON DELETE CASCADE;

--
-- 限制表 `operation_logs`
--
ALTER TABLE `operation_logs`
  ADD CONSTRAINT `fk_operation_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- 限制表 `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `fk_role_permissions_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_role_permissions_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- 限制表 `teams`
--
ALTER TABLE `teams`
  ADD CONSTRAINT `fk_teams_owner_id` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT;

--
-- 限制表 `team_invitations`
--
ALTER TABLE `team_invitations`
  ADD CONSTRAINT `fk_team_invitations_invitee_user_id` FOREIGN KEY (`invitee_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_team_invitations_inviter_id` FOREIGN KEY (`inviter_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_team_invitations_team_id` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE;

--
-- 限制表 `team_join_requests`
--
ALTER TABLE `team_join_requests`
  ADD CONSTRAINT `fk_team_join_requests_reviewed_by` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_team_join_requests_team_id` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_team_join_requests_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- 限制表 `team_members`
--
ALTER TABLE `team_members`
  ADD CONSTRAINT `fk_team_members_invited_by` FOREIGN KEY (`invited_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_team_members_team_id` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_team_members_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- 限制表 `user_login_logs`
--
ALTER TABLE `user_login_logs`
  ADD CONSTRAINT `fk_login_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- 限制表 `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `fk_user_roles_assigned_by` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_user_roles_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user_roles_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- 限制表 `user_verification_codes`
--
ALTER TABLE `user_verification_codes`
  ADD CONSTRAINT `fk_verification_codes_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
