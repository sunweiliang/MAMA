# 微信文字朗读插件 无需越狱~

微信文字朗读插件，帮助不识字的人读懂文字，能够跟正常跟朋友，家人互动，完全开源，无任何恶意代码。

### 版本支持

- iOS：微信7.0.0+（理论全版本）
- Android：暂无

### 安装

##### 1、越狱+插件包方式（theos）（推荐）

- 直接下载[release](https://github.com/sunweiliang/MAMA/releases)的deb安装到手机即可

  ```
  安装方式:
  1、将手机越狱
  2、借助工具安装（推荐爱思助手）
  3、手动安装
  	1.使用iFunBox将deb包拷贝到手机
  	2.Cyida中搜索Filza(文件管理器)，在Filza中找到deb，进行安装。
  ```

- 手动编译

  ```
  1、安装最新的theos
  	sudo git clone --recursive https://github.com/theos/theos.git /opt/theos
  2、安装ldid
  	brew install dpkg ldid
  3、安装xcode
  4、切换到项目theos目录中，编译deb
  	make package
  	多次编译需要先make clean，再make package
  5、packages文件夹为deb文件目录
  	
  ```

##### 2、重签名方式安装（Dylib）（容易冻结账号）

- 安装最新的theos

```
sudo git clone --recursive https://github.com/theos/theos.git /opt/theos
```

- 安装ldid(如安装theos过程安装了ldid，跳过)

```
brew install ldid
```

- 指定的Xcode

```
sudo xcode-select -s /Applications/Xcode.app
```

- 执行安装命令

```
sudo /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/AloneMonkey/MonkeyDev/master/bin/md-install)"
```

- 运行工程

```
- 由于包名冲突，需先删除微信。
- 讲脱壳后的微信拷贝至 工程/dylib/MAMA/MAMA/TargetApp
- 打开工程 MAMA/MAMA.xcodeproj
- 选择证书：Targets-General-Signing
- 选择设备(不可选择模拟器，且仅支持64位设备)运行。
```

### 使用

- 单机微信聊天框即可朗读文本消息

### 思路分析

```
1、hook点击事件，过滤非文本消息
	BaseMsgContentViewController  -  didSelectRowAtIndexPath
2、使用AVSpeechUtterance朗读文字
```

### 已知问题

- deb版本，领取红包次数过多时微信提示异常，猜测是微信反作弊系统误伤
- Dylib非越狱方式容易造成账号冻结-不推荐。

### 声明

- 身边有不识字的家人，见过他们使用微信时看不识字的样子，看着家人朋友在群里一言一语，而自己却无法参与，他们不应该因为不识字而失去正常使用微信的权利。
- 完全开源，无任何恶意代码（包括抢红包、修改步数功能）。
- 如有新的想法，请[issues](https://github.com/sunweiliang/MAMA/issues), 我会在第一时间回复。
- 最后，希望能够帮助到不识字的人群，带给他们快乐。

