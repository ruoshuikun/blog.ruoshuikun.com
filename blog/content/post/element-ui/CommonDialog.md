---
title: "CommonDialog"
date: 2023-03-15T11:20:28+08:00
draft: false
---


# 对话框的显示/隐藏，及相关配置

## 目录结构
```bash
.
.
├── App.vue
├── main.js # 全局配置组件
├── components
│   ├── Common
│   │   ├── CommonDialog # 弹窗组件
│   │   │   └── index.vue
└── views
    └── exampleCommon # 示例合集
        ├── components
        └── index.vue
```

## 举个例子
### index.vue文件
```vue
<template>
  <div>
    <!-- 组件合集 -->
    <CommonTitle>
      <span slot="name">组件合集</span>
      <template slot="oper-btn">
        <el-button v-waves class="green-btn" type="primary" @click="dialogDefaultAttributes.visible = true">
          大弹窗
        </el-button>
        <el-button v-waves class="green-btn" type="primary" @click="dialogMediumAttributes.visible = true">
          中弹窗
        </el-button>
        <el-button v-waves class="green-btn" type="primary" @click="dialogSmallAttributes.visible = true">
          小弹窗
        </el-button>
      </template>
    </CommonTitle>
    <!-- 大弹窗 -->
    <CommonDialog
      :title="`大弹窗`"
      :visible.sync="dialogDefaultAttributes.visible"
      :loading.sync="dialogDefaultAttributes.loading"
      @cancel="dialogDefaultAttributes.visible = false"
      @confirm="dialogDefaultConfirm"></CommonDialog>
    <!-- 中弹窗 -->
    <CommonDialog
      :title="`中弹窗`"
      size="medium"
      :visible.sync="dialogMediumAttributes.visible"
      :loading.sync="dialogMediumAttributes.loading"
      @cancel="dialogMediumAttributes.visible = false"
      @confirm="dialogMediumConfirm"></CommonDialog>
    <!-- 小弹窗-提示框 -->
    <CommonDialog
      :title="`提示`"
      size="small"
      :visible.sync="dialogSmallAttributes.visible"
      :loading.sync="dialogSmallAttributes.loading"
      @cancel="dialogSmallAttributes.visible = false"
      @confirm="dialogSmallConfirm">
      <div class="flex-x-start">
        <el-image style="width: 18px; height: 18px" :src="require('@/assets/icon/warning2x.png')" fit></el-image>
        <span class="deletetip">{{ tipsContent }}</span>
      </div>
    </CommonDialog>
  </div>
</template>

<script>
import waves from "@/directive/waves"; // waves directive

export default {
  name: "ExampleCommon",
  components: {},
  directives: { waves },
  data() {
    return {
      tipsContent: "此操作无法回滚，是否继续",
      // 大 Dialog 的配置
      dialogDefaultAttributes: {
        visible: false,
        loading: false,
      },
      // 中 Dialog 的配置
      dialogMediumAttributes: {
        visible: false,
        loading: false,
      },
      // 小 Dialog 的配置
      dialogSmallAttributes: {
        visible: false,
        loading: false,
      },
    };
  },
  methods: {
    dialogDefaultConfirm() {
      this.dialogDefaultAttributes.loading = true;
      setTimeout(() => {
        this.dialogDefaultAttributes.loading = false;
        this.dialogDefaultAttributes.visible = false;
      }, 1000);
    },
    dialogMediumConfirm() {
      this.dialogMediumAttributes.loading = true;
      setTimeout(() => {
        this.dialogMediumAttributes.loading = false;
        this.dialogMediumAttributes.visible = false;
      }, 1000);
    },
    dialogSmallConfirm() {
      this.dialogSmallAttributes.loading = true;
      setTimeout(() => {
        this.dialogSmallAttributes.loading = false;
        this.dialogSmallAttributes.visible = false;
      }, 1000);
    },
  },
};
</script>

<style lang="" scoped></style>

```

### CommonDialog【对话框本身】

>弹窗组件。只做展示，逻辑部分移交给它的父组件处理

```vue
<template>
  <el-dialog
    :visible.sync="visible"
    :before-close="handleBeforeClose"
    class="asset-form"
    :title="title"
    :append-to-body="appendToBody"
    :width="`${width}px`"
    @close="handleClose">
    <!-- dialog 主要的 -->
    <slot class="dialog-main">main</slot>
    <template slot="footer">
      <el-button v-if="showCancelButton" size="small" @click="cancel">{{ cancelButtonText }}</el-button>
      <el-button v-if="showConfirmButton" size="small" :loading="loading" type="primary" @click="confirm">
        {{ confirmButtonText }}
      </el-button>
    </template>
  </el-dialog>
</template>

<script>
/**
 * @desc: 弹窗组件。只做展示，逻辑部分移交给它的父组件处理，如：NewAndEdit.vue】
 * Attributes:
 *    title: "标题名称", // 标题，默认值: 标题名称
 *    visible: false, // 是否显示，默认值: false
 *    loading: false, // 确定按钮加载中效果，默认值: false
 *    size: "default", // 尺寸，默认值: "default"
 *    showCancelButton: true, // 是否显示取消按钮，默认值: true
 *    showConfirmButton: true, // 是否显示确定按钮，默认值: true
 *    cancelButtonText: "取 消", // 取消按钮的文本内容，默认值: 取 消
 *    confirmButtonText: "确 定", // 确定按钮的文本内容，默认值: 确 定
 *    appendToBody: true, // 是否将自身插入至 body 元素，默认值: true
 * Other:
 * @author: zhang lin
 * @update: 2023-03-14
 */

export default {
  name: "CommonDialog",
  props: {
    // 是否显示
    visible: {
      type: Boolean,
      default: false,
    },
    // 标题
    title: {
      type: String,
      default: "提示",
    },
    // 确定按钮加载中效果
    loading: {
      type: Boolean,
      default: false,
    },
    /*
      尺寸
      default 1040
      medium 800
      small 480
    */
    size: {
      type: String,
      default: "default",
    },
    // 显示取消按钮
    showCancelButton: {
      type: Boolean,
      default: true,
    },
    // 显示确定按钮
    showConfirmButton: {
      type: Boolean,
      default: true,
    },
    // 取消按钮名称
    cancelButtonText: {
      type: String,
      default: "取 消",
    },
    // 确定按钮名称
    confirmButtonText: {
      type: String,
      default: "确 定",
    },
    // isShowFooter: {
    //   //是否自定底部
    //   type: Boolean,
    //   default: true,
    // },
    // 是否将自身插入至 body 元素，有嵌套的弹窗时一定要设置
    appendToBody: {
      type: Boolean,
      default: true,
    },
  },
  data() {
    return {};
  },
  computed: {
    width() {
      switch (this.size) {
        case "medium":
          return "800";
        case "small":
          return "480";
        default:
          return "1040";
      }
    },
  },
  methods: {
    handleBeforeClose() {
      this.$emit("update:visible", false);
    },
    handleClose() {},
    cancel() {
      this.$emit("cancel");
    },
    confirm() {
      this.$emit("confirm");
    },
  },
};
</script>

<style lang="scss" scoped>
::v-deep .el-dialog__footer {
  padding: 0 24px 24px;
}
</style>
```

## Attributes
| 参数              | 说明                       | 类型    | 默认值    |
| ----------------- | -------------------------- | ------- | --------- |
| visible           | 对话框显示/隐藏            | boolean | false     |
| title             | 弹窗的标题                 | string  | 提示      |
| loading           | 确定按钮加载中效果         | boolean | false     |
| size              | 弹窗的尺寸                 | string  | "default" |
| showCancelButton  | 是否显示取消按钮           | boolean | true      |
| showConfirmButton | 是否显示确定按钮           | boolean | true      |
| cancelButtonText  | 取消按钮的文本内容         | string  | 取 消     |
| confirmButtonText | 确定按钮的文本内容         | string  | 确 定     |
| appendToBody      | 是否将自身插入至 body 元素 | boolean | true      |