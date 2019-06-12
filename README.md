# ProxyKit

## 第一部分：许可协议

本项目源代码改动自 https://github.com/zhuhaow/NEKit/ ，该项目的许可协议见下。本项目的所有变动也同样置于该许可协议之下发布

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

## 第二部分：改变

所有源代码尽可能从 NEKit 中复制，几个变化的部分包括

* Tunnel 改名为 Pipe，这是为了和 NE 中的 Packet Tunnel Provider 区分开来

* Port 改名为 IPort，因为 Foundation 里面已经有了一个 Port 类型了

* Utils.swift 去掉 GeoIPLookup，DNSSession.swift 去掉 countryCode

* 将原 ConnectSession.swift RuleManager.swift RawSocketFactory.swift 中必要的部分
  合并成 Helper.swift 放在 Pipe 目录下。这些都是将来需要扩展的功能
