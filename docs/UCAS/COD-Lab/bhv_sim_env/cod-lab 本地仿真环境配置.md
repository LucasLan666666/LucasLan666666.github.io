# cod-lab 本地仿真环境配置

经过亲身实践，本方法可以在 S-IDE 和 Ubuntu 22.04.4 LTS on Windows 10 x86_64 环境下成功进行软件编译和行为仿真。（其他 Linux 版本应该也可以......吧）

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

!!! warning
    下面这两步会很漫长，如果在 S-IDE 上编译可能会花较长时间（我测试 S-IDE 的时候开了 16 G，也整了快半小时）。此外，如果 S-IDE 分配的内存太小，可能因为内存占用过大被操作系统杀死进程（建议开 16 G，但注意个人申请的内存空间总和不要超过 20 G，避免浪费服务器资源）

```bash
make -j `nproc`
```

```bash
sudo make install
```

## mips-gcc

依次执行以下命令

```bash
cd && git clone https://github.com/rm-hull/barebones-toolchain.git
```

```bash
sudo ln -s ~/barebones-toolchain/cross/x86_64/bin/mips-gcc /usr/local/bin/mips-gcc
```

## 成功示例

以 `hello` 为例

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

![custom_cpu_test_1](assets/custom_cpu_test_1.png)

![custom_cpu_test_2](assets/custom_cpu_test_2.png)

!!! success
    成功完成行为仿真并在终端显示结果！！！
