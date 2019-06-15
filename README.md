# ProxyKit

## 第零部分：关于 NEKit-NG，写在最前面

本项目源代码改动自 https://github.com/zhuhaow/NEKit/ 

NEKit 是我最近工作中所严重依赖的开源项目；NEKit 非常成熟，涵盖了开发 macOS/iOS 代理应用
的方方面面，但我们的项目中正好各使用它的其中一部分。为了便于工作的继续开展和新人培训，萌生了
将 NEKit 进行分拆的想法

鉴于原作者在这个领域里开了新坑，似乎并没有在 NEKit 上继续花费太多的精力，而且 NEKit 自从
去年以来也仅仅只有一次 Swift 5.0 的兼容升级。所以冒昧得将新项目取名为 NEKit-NG，同时希望
这个仓库在未来能成为红鱼工作的一个重要基础

预计 NEKit 分拆为 ProxyKit、AdapterManager、PacketKit 等三部分；也可能会继续分拆出一
个 ResolverKit

NEKit-NG 基于 Swift 5；采用 Carthage 管理依赖

ProxyKit 是代理应用的核心，理解 NEKit-NG 或者说 NEKit 应该从这里开始

## 第一部分：许可协议

NEKit 的许可协议见下。本项目的所有变动也同样置于该许可协议之下发布

Copyright (c) 2016, Zhuhao Wang
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of NEKit nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## 第二部分：相比较 NEKit 的改变

所有源代码尽可能从 NEKit 中复制，几个变化的部分包括

* Tunnel 改名为 Pipe，这是为了和 NE 中的 Packet Tunnel Provider 区分开来

* Port 改名为 IPort，因为 Foundation 里面已经有了一个 Port 类型了

* Utils.swift 去掉 GeoIPLookup，DNSSession.swift 去掉 countryCode

* 将原 ConnectSession.swift RuleManager.swift RawSocketFactory.swift 中必要的部分
  合并成 Helper.swift 放在 Pipe 目录下。这些都是将来需要扩展的功能

* 假定您在同一个目录下同时 clone 了 NEKit 和 ProxyKit，可以在 ProxyKit 下执行脚本来对比
  异同：sh script/diff.sh ../NEKit

## 第三部分：上手

* 首先通过 Carthage 编译依赖

* 然后在 Xcode 中编译 ProxyKit target

* 最后编译 ProxyKit-Demo 项目，在模拟器中运行。它将在本机启动一个 HTTP 代理和一个 Socks5
  代理

## 第四部分：代码基础解读

* 网络(TCP层或应用层)每成功建立一条代理路径，在代码里就是创建了一个 Pipe，Pipe 的两头分别是
  ProxySocket 和 AdapterSocket

* ProxySocket 是代理协议的 local 端实现，比如 HTTP 代理，Socks5 代理。对于应用程序而言，
  只有这两个标准的代理协议是足够了

* AdapterSocket 是代理协议的 remote 端实现，在 ProxyKit 中现在只有一个 DirectAdapter，
  即网络直连。显然除了网络直连外，现实生活中我们有各种其它的 Adapter 需求，比如 SS，或者实现
  自定义网络协议的 Adapter；NEKit 中已有的各个 Adapter，我将放到独立的 AdapterManager
  项目里维护

* 具体到代理应用，还需要针对性得选择 Adapter 使用。这部分规则配置我也将放在 AdapterManager
  项目里

* 随着规则配置被抽出，相关的 DNSSession 等从逻辑上是没有必要留在 ProxyKit 项目里，但为了尽
  量减少对原项目代码的变更，接口层耦合比较紧密的还是留了下来

