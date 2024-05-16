# REPORT 2 16 位比较器实验

## 实验目的

1. 熟悉 vivado 编程, 调试
2. 熟悉简单比较器的工作原理
3. 通过简单模块例化, 连线实现复杂的数字电路
4. 利用所掌握的知识, 完成以下两道附加题:
    1. 编写 4 位超前进位加法器
    2. 利用 11 个 4 位超前进位加法器, 编写一个 32 位超前进位加法器

## 实验环境

|  操作系统  | Vivado 版本 |  FPGA 器件芯片型号  |
| :--------: | :---------: | :-----------------: |
| Windows 11 |   2017.1    | xc7vx485tffg 1157-1 |

## 原理说明

### 4 位比较器

1. 接受 5 个输入信号, 分别为两个 4 位二进制数 A, B, 以及三个控制信号 in_A_G_B, in_A_E_B, in_A_L_B.
    输出 3 个信号, 分别为 out_A_G_B, out_A_E_B, out_A_L_B.
2. 对于 out_A_G_B , 从 A 和 B 的最高位开始比较, 若 A 的最高位大于 B 的最高位, 则 out_A_G_B 为 1, 否则为 0.
    若 A 的最高位等于 B 的最高位, 则继续比较 A 和 B 的次高位, 若 A 的次高位大于 B 的次高位, 则 out_A_G_B 为 1, 否则为 0.
    以此类推, 直到比较完 A 和 B 的最低位. out_A_L_B 的比较规则类似.
    而对于 out_A_E_B, 则需要同时比较 A 和 B 的每一位, 直到比较到最低位.
3. 如果 A 与 B 的每一位都相等, 则查看控制信号:
    1. 当 in_A_G_B 为 1 时, 若 A > B, 则 out_A_G_B 为 1, 否则为 0.
    2. 当 in_A_E_B 为 1 时, 若 A = B, 则 out_A_E_B 为 1, 否则为 0.
    3. 当 in_A_L_B 为 1 时, 若 A < B, 则 out_A_L_B 为 1, 否则为 0.

### 16 位比较器

1. 接受 2 个输入信号, 分别为两个 4 位二进制数 A, B.
    输出 3 个信号, 分别为 out_A_G_B, out_A_E_B, out_A_L_B.
2. 在最低 4 位的比较器输入一个 0b010 (对应out_A_G_B = 0, out_A_E_B = 1, out_A_L_B = 0)的控制信号;
    再将 4 个 4 位比较器用 3 根 wire 串联在一起,以连接来自低位的比较结果;
    最终输出信号即为最高 4 位对应比较器的输出信号 out_A_G_B, out_A_E_B, out_A_L_B.

### 4 位超前进位加法器

1. 由全加器真值表可知, 向高位的进位信号在两种情况下产生:
   $$
   \begin{align}
        &A \cdot B = 1 \\
        &A + B = 1, C_{in} = 1
   \end{align}
   $$
2. 用 $C_i$ 表示第 $i$ 位的进位信号, 有:
   $$
   C_{i+1} = A_iB_i + (A_i + B_i)C_i
   $$
3. 设 $G_i = A_iB_i$ 为进位生成函数, $P_i = A_i + B_i$ 为进位传递函数, 则有:
    $$
    C_{i+1} = G_i + P_iC_i
    $$
    另一方面, 由于 $S_i = A_i \oplus B_i \oplus C_i$ , 且我们发现
    $$
    \begin{align}
    C_{i+1} &= A_iB_i + (A_i + B_i)C_i \\
            &= A_iB_i + (A_i \oplus B_i)C_i
    \end{align}
    $$
    因此可以将 $P_i$ 的定义修改成 $P_i = A_i \oplus B_i$
    于是有:
    $$
    \begin{align}
        C_0 &= C_{in} \\
        C_1 &= G_1 + P_1C_0 = G_1 + P_1C_{in} \\
        C_2 &= G_2 + P_2C_1 = G_2 + P_2(G_1 + P_1C_{in}) \\
            &= G_2 + P_2G_1 + P_2P_1C_{in} \\
        C_2 &= G_2 + P_2C_1 = G_2 + P_2(G_1 + P_1C_{in}) \\
            &= G_2 + P_2G_1 + P_2P_1C_{in} \\
        C_2 &= G_2 + P_2C_1 \\
            &= G_2 + P_2(G_1 + P_1C_{in}) \\
            &= G_2 + P_2G_1 + P_2P_1C_{in} \\
            &\cdots \\
        C_i &= G_{i-1} + P_{i-1}C_{i-1} \\
            &= G_{i-1} + P_{i-1}(G_{i-2} + P_{i-2}C_{i-2}) \\
            &= \sum_{j=1}^iP_jG_{j-1} + P_iP_{i-1}\cdots P_1C_{in}
    \end{align}
    $$
4. 而对于 4 位加法器, 只需要取:
   $$
   \begin{align}
        C_0 &= C_{in} \\
        C_1 &= G_1 + P_1C_0 = G_1 + P_1C_{in} \\
        C_2 &= G_2 + P_2C_1 = G_2 + P_2(G_1 + P_1C_{in}) = G_2 + P_2G_1 + P_2P_1C_{in} \\
        C_3 &= G_3 + P_3C_2 = G_3 + P_3(G_2 + P_2G_1 + P_2P_1C_{in}) \\
            &= G_3 + P_3G_2 + P_3P_2G_1 +  P_3P_2P_1C_{in}
   \end{align}
   $$

5. 设 4 位加法器输出的和为 $S$ , 输出的进位信号为 $C_{out}$ , 有:
   $$
   \begin{align}
        S_i &= A_i \oplus B_i \oplus C_i \\
            &= P_i \oplus C_i \\
        C_{out} &= C_4 \\
                &= G_4 + P_4C_3 \\
                &= G_4 + P_4(G_3 + P_3G_2 + P_3P_2G_1 + P_3P_2P_1C_{in}) \\
                &= G_4 + P_4G_3 + P_4P_3G_2 + P_4P_3P_2G_1 + P_4P_3P_2P_1C_{in}
   \end{align}
   $$
6. 至此, 则实现了 4 位超前进位加法器.

### 32 位超前进位加法器

![Fast_Carry_32](assets/Fast_Carry_32.png)

1. 我们首先需要对 4 位超前进位加法器的结构进行改良. 上文提到的 4 位超前进位加法器先将输入的 A 和 B 信号转化为 P 和 G 信号, 并与 Cin 一起进行运算, 最终输出 Si 和 Cout . 此处, 我们保留 Pin ( 4 位)以及 Gin ( 4 位)表示每一位接收到的传输信号和生成信号 (注意在 Verilog 代码中我定义的 Pin 和 Gin 接线为 [3:0], 则 Pin[0] ~ Pin[3] 对应上文提到的 $P_1$ ~ $P_4$ , 对于 Gin 信号同理) , 以及 Cin ( 1 位)表示加法器接收到的进位信号. 输出 Pout ( 1 位)和 Gout ( 1 位)表示整个加法器接收到 P 和 G 信号的总体,  C ( 4 位)表示整个加法器输出的每一位的进位信号.
2. 我们先考虑最低 16 位, 一共由 5 个 4 位超前进位加法器模块构成, 第一层分别是 f00, f01, f02, f03, 第二层是 f10. 不难发现, f10 与 f00 同样接收到 Cin 作为来自低位的进位输入. 此外, f10 还接受 f00 输出的 Pout 和 Gout 作为 f10 的输入 Pin[0] 和 Gin[0], 所以 f10 可以据此输出 C[1] 作为 f01 的进位输入, 以此类推, 便构建出该 16 位超前进位加法器. 借助 f10, 我们可以发现传输们的延迟最高只有 6 (每经过 1 个模块则增加了两个传输门(C[0] 除外, 因为 C[0] = Cin 直接接通)), 大大提高了效率.
3. 采用类似的思想, 可将按照第二步构建的 两个 16 位超前进位加法器再通过一个额外的模块 f20(就是第 3 层的加法器)连接起来. f20 接受来自 f10 的 Pout  和 Gout, 作为 f20 的输入 Pin[0] 和 Gin[0] 并也将 Cin 作为 f20 来自低位的进位输入. 此外, 输出 C[1] 作为 f04 和 f11 来自低位的进位输入. 可以发现最多只需要经过 10 个传输门.
4. 整个内部框架至此搭建完毕, 剩下部分只需要利用 P = A + B (根据真值表已等效替代为异或, 原因已述)和 G =  AB 得到来自低位的传输信号和生成信号, 并将 f00 至 f07 输出的 C0 和 P0 进行与运算, 即可得到总和 S. 最后将 f20 输出的 C2[2] 作为总输出进位信号 Cout = C2[2].

## 接口定义

### 4 位比较器

```Verilog
input  [ 3: 0] A,
input  [ 3: 0] B,
input          in_A_G_B,
input          in_A_E_B,
input          in_A_L_B,
output         out_A_G_B,
output         out_A_E_B,
output         out_A_L_B
```

### 16 位比较器

```Verilog
  input  [15: 0] A,
  input  [15: 0] B,
  output         out_A_G_B,
  output         out_A_E_B,
  output         out_A_L_B
```

### 4 位超前进位加法器

```Verilog
input  [ 3: 0] A,
input  [ 3: 0] B,
input          Cin,
output [ 3: 0] S,
output         Cout
```

### 32 位超前进位加法器

```Verilog
input  [31: 0] A,
input  [31: 0] B,
input          Cin,
output [31: 0] S,
output         Cout
```

## 调试过程及结果

### 4 位比较器

![fig1](assets/fig1.png)

### 16 位比较器

![fig2](assets/fig2.png)

### 4 位超前进位加法器

![fig3](assets/fig3.png)

### 32 位超前进位加法器

![fig4](assets/fig4.png)

## 实验总结

- 本次实验主要完成了比较器和超前进位加法器的设计. 其中比较器的设计较为简单, 而超前进位加法器的设计则需要对进位信号的生成和传递进行分析, 并利用生成和传递的关系, 通过递推的方式, 将 4 位超前进位加法器扩展到 32 位超前进位加法器.
- 注意到在 4 位超前进位加法器扩展到 32 位超前进位加法器的过程中, 不能单纯将 4 位超前进位加法器串联在一起, 因为这样会导致传输延迟过长, 从而影响整个加法器的性能. 因此, 我们需要对 4 位超前进位加法器的结构进行改良, 最终使得传输延迟最多只有 10 个传输门.
- 此外, 通过和同学的讨论, 我们对讲义所给的 32 位超前进位加法器结构进行了改良. 讲义上最终输出的进位信号由 f07 给出, 我们将其修改为 f20 的 C[2] 信号, 这样可以减少经过传输们的数量, 提高效率.
- 在这个过程中, 我对超前进位加法器有更深刻的认识, 这对我日后学习体系结构相关课程打下了坚实的根基.

## 源代码

### 4 位比较器

#### 设计文件

```Verilog
module comparator_4 (
    input  [ 3: 0] A,
    input  [ 3: 0] B,
    input          in_A_G_B,
    input          in_A_E_B,
    input          in_A_L_B,
    output         out_A_G_B,
    output         out_A_E_B,
    output         out_A_L_B
);

assign out_A_G_B = (  A[3] && ~B[3])
                || (( A[3] ==  B[3]) && ( A[2] && ~B[2]))
                || (( A[3] ==  B[3]) && ( A[2] ==  B[2]) && ( A[1] && ~B    [1]))
                || (( A[3] ==  B[3]) && ( A[2] ==  B[2]) && ( A[1] ==  B    [1]) && ( A[0] && ~B[0]))
                || (( A[3] ==  B[3]) && ( A[2] ==  B[2]) && ( A[1] ==  B    [1]) && ( A[0] ==  B[0]) && in_A_G_B);
assign out_A_L_B = ( ~A[3] &&  B[3])
                || (( A[3] ==  B[3]) && (~A[2] &&  B[2]))
                || (( A[3] ==  B[3]) && ( A[2] ==  B[2]) && (~A[1] &&  B    [1]))
                || (( A[3] ==  B[3]) && ( A[2] ==  B[2]) && ( A[1] ==  B    [1]) && (~A[0] &&  B[0]))
                || (( A[3] ==  B[3]) && ( A[2] ==  B[2]) && ( A[1] ==  B    [1]) && ( A[0] ==  B[0]) && in_A_G_B);
assign out_A_E_B = (  A[3] ==  B[3]) && ( A[2] ==  B[2]) && ( A[1] ==  B    [1]) && ( A[0] ==  B[0]) && in_A_E_B;
endmodule
```

#### 示例文件(略)

#### 激励测试文件(仅展示自己编辑部分)

```Verilog
comparator_4 instance_comparator_4 (
    .A          (             A),
    .B          (             B),
    .in_A_G_B   (      in_A_G_B),
    .in_A_E_B   (      in_A_E_B),
    .in_A_L_B   (      in_A_L_B),
    .out_A_G_B  (USER_A_G_B_TMP),
    .out_A_E_B  (USER_A_E_B_TMP),
    .out_A_L_B  (USER_A_L_B_TMP)
);
```

### 16 位比较器

#### 设计文件

```Verilog
module comparator_16 (
    input  [15: 0] A,
    input  [15: 0] B,
    output         out_A_G_B,
    output         out_A_E_B,
    output         out_A_L_B
);

    wire   [ 2: 0] w0;
    wire   [ 2: 0] w1;
    wire   [ 2: 0] w2;
    wire   [ 2: 0] w3;

    assign w0 = 3'b010;

    comparator_4 m1(A[ 3: 0], B[ 3: 0], w0[0], w0[1], w0[2], w1[0]    , w1[1]    , w1[2]    );
    comparator_4 m2(A[ 7: 4], B[ 7: 4], w1[0], w1[1], w1[2], w2[0]    , w2[1]    , w2[2]    );
    comparator_4 m3(A[11: 8], B[11: 8], w2[0], w2[1], w2[2], w3[0]    , w3[1]    , w3[2]    );
    comparator_4 m4(A[15:12], B[15:12], w3[0], w3[1], w3[2], out_A_G_B, out_A_E_B, out_A_L_B);
endmodule

module comparator_4 (
    input  [ 3: 0] A,
    input  [ 3: 0] B,
    input          in_A_G_B,
    input          in_A_E_B,
    input          in_A_L_B,
    output         out_A_G_B,
    output         out_A_E_B,
    output         out_A_L_B
);

    assign out_A_G_B = (  A[3] && ~B[3])
                    || (( A[3] ==  B[3]) && ( A[2] && ~B[2]))
                    || (( A[3] ==  B[3]) && ( A[2] ==  B[2]) && ( A[1] && ~B[1]))
                    || (( A[3] ==  B[3]) && ( A[2] ==  B[2]) && ( A[1] ==  B[1]) && ( A[0] && ~B[0]))
                    || (( A[3] ==  B[3]) && ( A[2] ==  B[2]) && ( A[1] ==  B[1]) && ( A[0] ==  B[0]) && in_A_G_B);
    assign out_A_L_B = ( ~A[3] &&  B[3])
                    || (( A[3] ==  B[3]) && (~A[2] &&  B[2]))
                    || (( A[3] ==  B[3]) && ( A[2] ==  B[2]) && (~A[1] &&  B[1]))
                    || (( A[3] ==  B[3]) && ( A[2] ==  B[2]) && ( A[1] ==  B[1]) && (~A[0] &&  B[0]))
                    || (( A[3] ==  B[3]) && ( A[2] ==  B[2]) && ( A[1] ==  B[1]) && ( A[0] ==  B[0]) && in_A_L_B);
    assign out_A_E_B = (  A[3] ==  B[3]) && ( A[2] ==  B[2]) && ( A[1] ==  B[1]) && ( A[0] ==  B[0]) && in_A_E_B;
endmodule
```

#### 示例文件(略)

#### 激励测试文件(仅展示自己编辑部分)

```Verilog
comparator_16 instance_comparator_16 (
    .A              (               A),
    .B              (               B),
    .out_A_G_B      (  USER_A_G_B_TMP),
    .out_A_E_B      (  USER_A_E_B_TMP),
    .out_A_L_B      (  USER_A_L_B_TMP)
);
```

### 4 位超前进位加法器

#### 设计文件

```Verilog
module fastcarry_4 (
    input  [ 3: 0] A,
    input  [ 3: 0] B,
    input          Cin,
    output [ 3: 0] S,
    output         Cout
);

    wire   [ 3: 0] C;
    wire   [ 3: 0] P;
    wire   [ 3: 0] G;

    PG_generator t0 (A[0], B[0], P[0], G[0]);
    PG_generator t1 (A[1], B[1], P[1], G[1]);
    PG_generator t2 (A[2], B[2], P[2], G[2]);
    PG_generator t3 (A[3], B[3], P[3], G[3]);

    assign  C[0] = Cin;
    assign  C[1] = G[0]
                || P[0] && Cin;
    assign  C[2] = G[1]
                || P[1] && G[0]
                || P[1] && P[0] && Cin;
    assign  C[3] = G[2]
                || P[2] && G[1]
                || P[2] && P[1] && G[0]
                || P[2] && P[1] && P[0] && Cin;
    assign  Cout = G[3]
                || P[3] && G[2]
                || P[3] && P[2] && G[1]
                || P[3] && P[2] && P[1] && G[0]
                || P[3] && P[2] && P[1] && P[0] && Cin;
    assign     S = P ^ C;
endmodule

module PG_generator (
    input          a,
    input          b,
    output         p,
    output         g
);

    assign  p = a ^ b;
    assign  g = a & b;
endmodule
```

#### 示例文件

```Verilog
module TEMPLATE_fastcarry_4 (A, B, Cin, S, Cout);
    input  [ 3: 0] A;
    input  [ 3: 0] B;
    input          Cin;
    output [ 3: 0] S;
    output         Cout;

    assign {Cout, S} = A + B + Cin;
endmodule
```

#### 激励测试文件

```Verilog
module test_fastcarry_4();
    reg   [3:0] A;
    reg   [3:0] B;
    reg         Cin;
    wire  [3:0] S1;
    wire        Cout1;
    wire  [3:0] S2;
    wire        Cout2;
    wire        check = (   S1 === S2   )
                        && (Cout1 === Cout2);

    fastcarry_4 instance_fastcarry_4 (
        .A    (          A),
        .B    (          B),
        .Cin  (        Cin),
        .S    (         S1),
        .Cout (      Cout1)
    );

    TEMPLATE_fastcarry_4 instance_TEMPLATE_fastcarry_4 (
        .A    (          A),
        .B    (          B),
        .Cin  (        Cin),
        .S    (         S2),
        .Cout (      Cout2)
    );

    initial
    begin
            A = 4'd0;
            B = 4'd0;
        Cin = 1'b0;
    end

    always
    begin
        #2;
            A = $random() % 16;
            B = $random() % 16;
        Cin = $random() %  2;
    end
endmodule
```

### 32 位超前进位加法器

```Verilog
module fastcarry_32 (
    input  [31: 0] A,
    input  [31: 0] B,
    input          Cin,
    output [31: 0] S,
    output         Cout
);

    wire   [31: 0] P0;
    wire   [31: 0] G0;
    wire   [31: 0] C0;
    wire   [ 7: 0] P1;
    wire   [ 7: 0] G1;
    wire   [ 7: 0] C1;
    wire   [ 3: 0] P2;
    wire   [ 3: 0] G2;
    wire   [ 3: 0] C2;

    assign    P0 =  A ^ B;
    assign    G0 =  A & B;
    assign     S = P0 ^ C0;
    assign  Cout = C[2];

    fastcarry_4_2  f00 (
        .Pin  ( P0 [ 3: 0]),
        .Gin  ( G0 [ 3: 0]),
        .Cin  (Cin        ),
        .C    ( C0 [ 3: 0]),
        .Pout ( P1 [    0]),
        .Gout ( G1 [    0])
    );

    fastcarry_4_2  f01 (
        .Pin  ( P0 [ 7: 4]),
        .Gin  ( G0 [ 7: 4]),
        .Cin  ( C1 [    1]),
        .C    ( C0 [ 7: 4]),
        .Pout ( P1 [    1]),
        .Gout ( G1 [    1])
    );
    fastcarry_4_2  f02 (
        .Pin  ( P0 [11: 8]),
        .Gin  ( G0 [11: 8]),
        .Cin  ( C1 [    2]),
        .C    ( C0 [11: 8]),
        .Pout ( P1 [    2]),
        .Gout ( G1 [    2])
    );
    fastcarry_4_2  f03 (
        .Pin  ( P0 [15:12]),
        .Gin  ( G0 [15:12]),
        .Cin  ( C1 [    3]),
        .C    ( C0 [15:12]),
        .Pout ( P1 [    3]),
        .Gout ( G1 [    3])
    );
    fastcarry_4_2  f04 (
        .Pin  ( P0 [19:16]),
        .Gin  ( G0 [19:16]),
        .Cin  ( C2 [    1]),
        .C    ( C0 [19:16]),
        .Pout ( P1 [    4]),
        .Gout ( G1 [    4])
    );
    fastcarry_4_2  f05 (
        .Pin  ( P0 [23:20]),
        .Gin  ( G0 [23:20]),
        .Cin  ( C1 [    5]),
        .C    ( C0 [23:20]),
        .Pout ( P1 [    5]),
        .Gout ( G1 [    5])
    );
    fastcarry_4_2  f06 (
        .Pin  ( P0 [27:24]),
        .Gin  ( G0 [27:24]),
        .Cin  ( C1 [    6]),
        .C    ( C0 [27:24]),
        .Pout ( P1 [    6]),
        .Gout ( G1 [    6])
    );
    fastcarry_4_2  f07 (
        .Pin  ( P0 [31:28]),
        .Gin  ( G0 [31:28]),
        .Cin  ( C1 [    7]),
        .C    ( C0 [31:28]),
        .Pout ( P1 [    7]),
        .Gout ( G1 [    7])
    );
    fastcarry_4_2  f10 (
        .Pin  ( P1 [ 3: 0]),
        .Gin  ( G1 [ 3: 0]),
        .Cin  (Cin        ),
        .C    ( C1 [ 3: 0]),
        .Pout ( P2 [    0]),
        .Gout ( G2 [    0])
    );
    fastcarry_4_2  f11 (
        .Pin  ( P1 [ 7: 4]),
        .Gin  ( G1 [ 7: 4]),
        .Cin  ( C2 [    1]),
        .C    ( C1 [ 7: 4])
    );
    fastcarry_4_2  f20 (
        .Pin  ( P2 [ 3: 0]),
        .Gin  ( G2 [ 3: 0]),
        .Cin  (Cin        ),
        .C    ( C2 [ 3: 0])
    );
endmodule
module fastcarry_4_2 (
    input  [ 3: 0] Pin,
    input  [ 3: 0] Gin,
    input          Cin,
    output [ 3: 0] C,
    output         Pout,
    output         Gout
);
    assign  C[0] = Cin;
    assign  C[1] = Gin[0]
                || Pin[0] && Cin;
    assign  C[2] = Gin[1]
                || Pin[1] && Gin[0]
                || Pin[1] && Pin[0] && Cin;
    assign  C[3] = Gin[2]
                || Pin[2] && Gin[1]
                || Pin[2] && Pin[1] && Gin[0]
                || Pin[2] && Pin[1] && Pin[0] && Cin;
    assign  Gout = Gin[3]
                || Pin[3] && Gin[2]
                || Pin[3] && Pin[2] && Gin[1]
                || Pin[3] && Pin[2] && Pin[1] && Gin[0];
    assign  Pout = Pin[3] && Pin[2] && Pin[1] && Pin[0];
endmodule
```

#### 示例文件

```Verilog
module TEMPLATE_fastcarry_32 (A, B, Cin, S, Cout);
    input  [31: 0] A;
    input  [31: 0] B;
    input          Cin;
    output [31: 0] S;
    output         Cout;

    assign {Cout, S} = A + B + Cin;
endmodule
```

#### 激励测试文件

```Verilog
module test_fastcarry_32();
    reg   [31:0] A;
    reg   [31:0] B;
    reg          Cin;
    wire  [31:0] S1;
    wire         Cout1;
    wire  [31:0] S2;
    wire         Cout2;
    wire         check = (   S1 === S2   )
                        && (Cout1 === Cout2);

    fastcarry_32 instance_fastcarry_32 (
        .A    (          A),
        .B    (          B),
        .Cin  (        Cin),
        .S    (         S1),
        .Cout (      Cout1)
    );

    TEMPLATE_fastcarry_32 instance_TEMPLATE_fastcarry_32 (
        .A    (          A),
        .B    (          B),
        .Cin  (        Cin),
        .S    (         S2),
        .Cout (      Cout2)
    );

    initial
    begin
            A = 32'h0;
            B = 32'h0;
          Cin =  1'b0;
    end

    always
    begin
        #2;
            A = $random() % 2^32;
            B = $random() % 2^32;
          Cin = $random() %    2;
    end
endmodule
```
