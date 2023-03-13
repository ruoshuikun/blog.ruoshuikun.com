---
title: "CommonDialogBig"
date: 2023-03-13T16:07:06+08:00
draft: false
---

# 弹窗的显示/隐藏

>采用 `provide` / `inject` 的方式触发事件【子/孙组件接收父组件注入】

## 目录结构
```bash
.
├── components
│   ├── NewAndEdit.vue
└── index.vue
```

## 举个例子
### index.vue文件
```vue
<template>  
  <div>  
    <NewAndEdit/>  
  </div>  
</template>  
  
<script>  
import NewAndEdit from "./components/NewAndEdit.vue";

export default {  
  name: "parent",  
  components: { NewAndEdit },   
  data() {  
    return {  
      // 大弹窗的配置
      dialogBig: {
        visible: false,
      },  
    };  
  },
  provide() {
    return {
      dialogBigVisible: this.dialogBig,
    };
  },  
};  
</script>
```

### NewAndEdit.vue

>子组件

```vue
<template>  
  <CommonDialogBig 
    @confirm="commonDialogConfirm" 
    @cancel="commonDialogCancel"
    :loading="commonDialogBigLoading"
  >
	  <el-form>
	  <!-- form 表单部分 -->
	  </el-form>
  </CommonDialogBig>
</template>  
  
<script> 
export default {  
  name: "parent",  
  components: { Son },   
  data() {  
    return {  
      commonDialogBigLoading: false, // 大弹窗确定按钮的loading		  
    };  
  }, 
  methods: {
    /* 大弹窗的取消、确认事件 begin */
    commonDialogCancel() {
      console.log("大弹窗-子组件取消了");
      this.dialogBigVisible.visible = false;
    },
    commonDialogConfirm() {
      console.log("大弹窗-子组件确认了");
      this.commonDialogBigLoading = true;
      // 模拟接口请求，给按钮添加loading的效果
      setTimeout(() => {
        this.commonDialogBigLoading = false;
        this.dialogBigVisible.visible = false;
      }, 1000);
    },
    /* 大弹窗的取消、确认事件 end */
  },
};  
</script>
```

### CommonDialogBig【大弹窗本身】

>孙子组件，只做展示，逻辑部分移交给它的父组件NewAndEdit.vue处理】

```vue
<template>
  <el-dialog
    :visible.sync="dialogBigVisible.visible"
    :before-close="handleBeforeClose"
    width="1040px"
    class="asset-form"
    :title="title"
    @close="handleClose">
    <!-- dialog 主要的 -->
    <slot class="dialog-main">main</slot>
    <template slot="footer">
      <el-button v-if="showCancelButton" @click="cancel">{{ cancelButtonText }}</el-button>
      <el-button v-if="showConfirmButton" :loading="loading" type="primary" @click="confirm">
        {{ confirmButtonText }}
      </el-button>
    </template>
  </el-dialog>
</template>

<script>
/**
 * @desc: 大弹窗组件。只做展示，逻辑部分移交给它的父组件处理，如：NewAndEdit.vue】
 * Options:
 *    title: "标题名称", // 弹窗的标题，默认值: 标题名称
 *    showCancelButton: true, // 是否显示取消按钮，默认值: true
 *    showConfirmButton: true, // 是否显示确定按钮，默认值: true
 *    cancelButtonText: "取 消", // 取消按钮的文本内容，默认值: 取 消
 *    confirmButtonText: "确 定", // 确定按钮的文本内容，默认值: 确 定
 * Other:
 *    采用 provide/inject 的方式触发事件【子/孙组件接收了父组件注入】
 * @author: zhang lin
 * @update: 2023-03-13
 */

export default {
  name: "",
  inject: ["dialogBigVisible"],
  props: {
    loading: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      title: "标题名称", // 弹窗的标题，默认值: 标题名称
      showCancelButton: true, // 是否显示取消按钮，默认值: true
      showConfirmButton: true, // 是否显示确定按钮，默认值: true
      cancelButtonText: "取 消", // 取消按钮的文本内容，默认值: 取 消
      confirmButtonText: "确 定", // 确定按钮的文本内容，默认值: 确 定
    };
  },
  created() {
    const { title, showCancelButton, showConfirmButton, cancelButtonText, confirmButtonText } = this.dialogBigVisible;

    // 大弹窗文本内容替换
    if (typeof title === "string" && title) {
      this.title = title;
    }
    // 隐藏取消按钮
    if (typeof showCancelButton === "boolean" && !showCancelButton) {
      this.showCancelButton = showCancelButton;
    }
    // 隐藏确认按钮
    if (typeof showConfirmButton === "boolean" && !showConfirmButton) {
      this.showConfirmButton = showConfirmButton;
    }
    // 取消按钮文本内容替换
    if (typeof cancelButtonText === "string" && cancelButtonText) {
      this.cancelButtonText = cancelButtonText;
    }
    // 确认按钮文本内容替换
    if (typeof confirmButtonText === "string" && confirmButtonText) {
      this.confirmButtonText = confirmButtonText;
    }
  },
  methods: {
    handleBeforeClose() {
      // 关闭弹窗的示例
      // this.dialogBigVisible.visible = false;
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

## Options
| 参数              | 说明               | 类型    | 默认值 |
| ----------------- | ------------------ | ------- | ------ |
| title             | 弹窗的标题         | string  | 大弹窗 |
| showCancelButton  | 是否显示取消按钮   | boolean | true   |
| showConfirmButton | 是否显示确定按钮   | boolean | true   |
| cancelButtonText  | 取消按钮的文本内容 | string  | 取 消  |
| confirmButtonText | 确定按钮的文本内容 | string  | 确 定  |
