---
title: "CommonDialogSmall"
date: 2023-03-14T14:06:52+08:00
draft: false
---

# 对话框的显示/隐藏，及相关配置

>采用 `provide` / `inject` 的方式触发事件【子/孙组件接收父组件注入】

## 目录结构
```bash
.
.
├── App.vue
├── main.js # 全局配置组件
├── components
│   ├── Common
│   │   ├── CommonDialogBig # 大弹窗组件
│   │   │   └── index.vue
│   │   ├── CommonDialogMedium # 中弹窗组件
│   │   │   └── index.vue
│   │   ├── CommonDialogSmall # 小弹窗组件
│   │   │   └── index.vue
└── views
    └── exampleCommon
        ├── components
        │   ├── NewAndEditBig.vue # 大弹窗组件使用
        │   ├── NewAndEditMedium.vue # 中弹窗组件使用
        │   └── NewAndEditSmall.vue # 小弹窗组件使用
        └── index.vue
```

## 举个例子
### index.vue文件
```vue
<template>  
  <div>  
    <NewAndEditSmall/>  
  </div>  
</template>  
  
<script>  
import NewAndEditSmall from "./components/NewAndEditSmall.vue";

export default {  
  name: "ExampleCommon",  
  components: { NewAndEditSmall },   
  data() {  
    return {  
      // 小弹窗的配置
      dialogSmall: {
        visible: false, // 弹窗显示隐藏
        title: "小弹窗", // 弹窗的标题
        // showCancelButton: false, // 是否显示取消按钮
        // showConfirmButton: false, // 是否显示确定按钮
        // cancelButtonText: "重 置", // 取消按钮的文本内容
        // confirmButtonText: "创 建", // 确定按钮的文本内容
        confirmButtonLoading: false, // 确定按钮的loading
      }, 
    };  
  },
  provide() {
    return {
      dialogSmallAttributes: this.dialogSmall,
    };
  },  
};  
</script>
```

### NewAndEditSmall.vue

>子组件

这里直接使用 `<CommonDialogMedium>` 组件是因为在 `main.js` 已经引入

```vue
<template>
  <CommonDialogSmall @confirm="commonDialogConfirm" @cancel="commonDialogCancel">
    <div class="flex-x-start">
      <el-image style="width: 18px; height: 18px" :src="require('@/assets/icon/warning2x.png')" fit></el-image>
      <span class="deletetip">{{ tipsContent }}</span>
    </div>
  </CommonDialogSmall>
</template>

<script>
export default {
  name: "NewAndEditSmall",
  inject: ["dialogSmallAttributes"],
  props: {},
  data() {
    return {
      tipsContent: "此操作将永久删除，是否继续？",
    };
  },
  methods: {
    /* 小弹窗的取消、确认事件 begin */
    commonDialogCancel() {
      console.log("小弹窗-子组件取消了");
      this.dialogSmallAttributes.visible = false;
    },
    commonDialogConfirm() {
      console.log("小弹窗-子组件确认了");
      this.dialogSmallAttributes.confirmButtonLoading = true;
      // 模拟接口请求，给按钮添加loading的效果
      setTimeout(() => {
        this.dialogSmallAttributes.confirmButtonLoading = false;
        this.dialogSmallAttributes.visible = false;
      }, 1000);
    },
    /* 小弹窗的取消、确认事件 end */
  },
};
</script>

<style lang="" scoped></style>
```

### CommonDialogSmall【小弹窗本身】

>孙子组件，只做展示，逻辑部分移交给它的父组件NewAndEditMedium.vue处理】

```vue
<template>
  <el-dialog
    :visible.sync="dialogSmallAttributes.visible"
    :before-close="handleBeforeClose"
    width="480px"
    class="asset-form"
    :title="title"
    @close="handleClose">
    <!-- dialog 主要的 -->
    <slot class="dialog-main">main</slot>
    <template slot="footer">
      <el-button v-if="showCancelButton" size="small" @click="cancel">{{ cancelButtonText }}</el-button>
      <el-button v-if="showConfirmButton" size="small" :loading="confirmButtonLoading" type="primary" @click="confirm">
        {{ confirmButtonText }}
      </el-button>
    </template>
  </el-dialog>
</template>

<script>
/**
 * @desc: 小弹窗组件。只做展示，逻辑部分移交给它的父组件处理，如：index.vue】
 * Options:
 *    title: "标题名称", // 弹窗的标题，默认值: 标题名称
 *    showCancelButton: true, // 是否显示取消按钮，默认值: true
 *    showConfirmButton: true, // 是否显示确定按钮，默认值: true
 *    cancelButtonText: "取 消", // 取消按钮的文本内容，默认值: 取 消
 *    confirmButtonText: "确 定", // 确定按钮的文本内容，默认值: 确 定
 *    confirmButtonLoading: false, // 确定按钮的loading，默认值: false
 *    confirmButtonLoading: false, // 确定按钮的loading-如果配置confirmButtonLoading，则显示loading效果
 * Other:
 *    采用 provide/inject 的方式触发事件【子/孙组件接收了父组件注入】
 * @author: zhang lin
 * @update: 2023-03-13
 */

export default {
  name: "CommonDialogSmall",
  inject: ["dialogSmallAttributes"],
  props: {},
  data() {
    return {};
  },
  computed: {
    // 弹窗的标题，默认值: 标题名称
    title() {
      return this.dialogSmallAttributes.title || "标题名称";
    },
    // 是否显示取消按钮，默认值: true
    showCancelButton() {
      const { showCancelButton } = this.dialogSmallAttributes;
      if (typeof showCancelButton === "boolean" && !showCancelButton) {
        return false;
      }
      return true;
    },
    // 是否显示确定按钮，默认值: true
    showConfirmButton() {
      const { showConfirmButton } = this.dialogSmallAttributes;
      if (typeof showConfirmButton === "boolean" && !showConfirmButton) {
        return false;
      }
      return true;
    },
    // 取消按钮的文本内容，默认值: 取 消
    cancelButtonText() {
      return this.dialogSmallAttributes.cancelButtonText || "取 消";
    },
    // 确定按钮的文本内容，默认值: 确 定
    confirmButtonText() {
      return this.dialogSmallAttributes.confirmButtonText || "确 定";
    },
    // 确定按钮的loading-如果配置confirmButtonLoading，则显示loading效果
    confirmButtonLoading() {
      return this.dialogSmallAttributes.confirmButtonLoading || false;
    },
  },
  methods: {
    handleBeforeClose() {
      this.dialogSmallAttributes.visible = false;
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
| 参数                 | 说明               | 类型    | 默认值 |
| -------------------- | ------------------ | ------- | ------ |
| visible              | 对话框显示/隐藏    | boolean | false  |
| title                | 弹窗的标题         | string  | 小弹窗 |
| showCancelButton     | 是否显示取消按钮   | boolean | true   |
| showConfirmButton    | 是否显示确定按钮   | boolean | true   |
| cancelButtonText     | 取消按钮的文本内容 | string  | 取 消  |
| confirmButtonText    | 确定按钮的文本内容 | string  | 确 定  |
| confirmButtonLoading | 确定按钮的loading  | boolean | -      |