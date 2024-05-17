# cod-lab 本地仿真环境配置

经过亲身实践，本方法可以在 S-IDE 和 Ubuntu 22.04.4 LTS on Windows 10 x86_64 环境下成功进行软件编译和行为仿真。（其他 Linux 版本应该也可以......吧）

!!! note
    如果是在一个新环境下从零开始配置，需要重新设置好 git 的用户名和邮箱，配置 ssh key（不然没法拉取和上传自己仓库）并添加好实验框架的远程仓库（就是那个 `upstream` ），以及 IDE 的插件（详情参考张思老师的文档 [hello SERVE](https://gitlab.agileserve.org.cn:8001/zhangsi/hello-serve) ）

## verilator

在 [这里](https://github.com/verilator/verilator/releases/tag/v4.222) 下载 4.222 版本的 `verilator` 。

![verilator](assets/verilator.png)

找一个目录（不要放到框架里，可以选择 `~` 主目录）本地解压即可，用以下命令解压：

```bash
tar -xvf verilator-4.222.tar.gz
```

然后移动至解压后的目录：

 ```bash
 cd verilator-4.222
 ```

依次执行以下命令:

首先安装必备的依赖：

```bash
sudo apt-get install git help2man perl python3 make autoconf g++ flex bison ccache libgoogle-perftools-dev numactl perl-doc
```

生成配置脚本：

```bash
autoconf && ./configure
```

编译安装：

!!! warning
    下面这两步会很漫长，如果在 S-IDE 上编译可能会花较长时间（我测试 S-IDE 的时候开了 16 G，也整了快半小时）。

```bash
make -j `nproc`
```

!!! note
    最新补充：如果上一条指令不能成功执行，可以直接改用 `make` ，不加任何参数（后来了解到 `-j` 参数作用是利用多个处理器核心加速优化，但是在 S-IDE 上反而会出现因内存占用过大被操作系统杀死进程的情况，稳妥起见还是用 `make` 吧）

最后输入下面指令，即可完成 `mips-gcc` 的最终安装步骤：

```bash
sudo make install
```

在终端输入以下指令，检查是否安装成功：

```bash
verialtor --version
```

!!! success
    如果终端打印出 `Verilator 4.222 2022-05-02 rev UNKNOWN.REV` 字样，表示 `verilator` 本地配置成功。

## mips-gcc

依次执行以下命令

```bash
cd && git clone https://github.com/rm-hull/barebones-toolchain.git
```

```bash
sudo ln -s ~/barebones-toolchain/cross/x86_64/bin/mips-gcc /usr/local/bin/mips-gcc
```

在终端输入以下指令，检查是否安装成功：

```bash
mips-gcc --version
```

!!! success
    如果终端打印出以下类似字样，表示 `mips-gcc` 本地配置成功。
    ```bash
    mips-gcc (GCC) 6.2.0
    Copyright (C) 2016 Free Software Foundation, Inc.
    This is free software; see the source for copying conditions.  There is NO
    warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    ```

## 成功示例（以 `hello` 为例）

!!! warning
    记得用 `git pull upstream master` 同步框架！！！

### 软件部分

!!! tip
    没错它就是这么长

![software_test_1](assets/software_test_1.png)
![software_test_2](assets/software_test_2.png)
![software_test_3](assets/software_test_3.png)
![software_test_4](assets/software_test_4.png)

!!! success
    成功编译软件！！！

### 硬件部分

!!! warning
    记得先把 `fpga/sim_out/custom_cpu` 和 `verilator_include` 删干净！！！

!!! warning
    `make` 前要加 `sudo`

![custom_cpu_test_1](assets/custom_cpu_test_1.png)

![custom_cpu_test_2](assets/custom_cpu_test_2.png)

!!! success
    成功完成行为仿真并在终端显示结果！！！
