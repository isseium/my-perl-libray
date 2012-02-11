# (Test::File::Maker.pm: まだクラス化してません)
# 
# @author isseium
# 
# 指定したパターンでファイルを作成する
# データパターン網羅試験などで利用することを想定
#
# サンプル
#
# my @ret = comb(
#             {'JAPAN' =>
#                 {'TOKYO' =>
#                     {'SHIBUYA', 'ROPPONGI'},
#                  'IWATE' =>
#                     {'MORIOKA', 'KITAKAMI'}
#                 },
#              'U.S.A' =>
#                 {'NewYork' => {'CityOfNY'}}
#             }, [5, 9, 3]
#           );
# 
# for (@ret){
#     print join("\t", @$_). "\n";
# }
# 
# 結果:
# JAPAN   IWATE   MORIOKA     5
# JAPAN   IWATE   MORIOKA     9
# JAPAN   IWATE   MORIOKA     3
# JAPAN   IWATE   KITAKAMI    5
# JAPAN   IWATE   KITAKAMI    9
# JAPAN   IWATE   KITAKAMI    3
# JAPAN   TOKYO   SHIBUYA     5
# JAPAN   TOKYO   SHIBUYA     9
# JAPAN   TOKYO   SHIBUYA     3
# JAPAN   TOKYO   ROPPONGI    5
# JAPAN   TOKYO   ROPPONGI    9
# JAPAN   TOKYO   ROPPONGI    3
# U.S.A   NewYork CityOfNY    5
# U.S.A   NewYork CityOfNY    9
# U.S.A   NewYork CityOfNY    3
#
#
# 開発中です。テストとかまともにしていません。
# どうせすぐできるんだろうと思ったら意外と複雑なコードになってしまいました...
#
# 今後の方針:
#  クラス化
#  テストスクリプト書く
#  リファクタリング
#
# ライセンス:
#   よくわからないけど MIT License とします。
#
# 表記:
#  @TODO     今後対応したいこと
#  @XXX      使い方によっては一部バグあり
#  @FIXME    バグあるよ
#

our $VERSION = 0.00001;

use strict;

# @TODO 下記警告がでるので、この警告は無視するように対応したい
# Odd number of elements in anonymous hash at 
use warnings;

sub comb {
    my ($x) = (shift);
    my @result = ();
    my $num = @_;

    # HASH のときは順序付き組み合わせとする
    if(ref($x) eq 'HASH'){
        my @hash_parm = parm($x);
        $x = \@hash_parm;
    }

    # 子孫がいないときはリストとして返す
    if($num == 0){
        for my $t1 (@$x){
            my @t1;
            if(ref($t1) eq 'ARRAY'){
                @t1 = @$t1;
            }else{
                @t1 = $t1
            }

            push(@result, [@t1]);
        }
        return @result;
    }else{
        # 子孫のリストを取得
        my @child = comb(@_);

        # 子孫がいるときは、子との組み合わせを返す
        for my $t1 (@$x){
            my @t1;
            if(ref($t1) eq 'ARRAY'){
                @t1 = @$t1;
            }else{
                @t1 = $t1
            }

            for my $t2 (@child){
                push(@result, [@t1, @$t2]);
            }
        }
    }

    return @result;
}

sub parm {
    my ($x) = (shift);
    my @result = ();

    my @keys = keys %$x;
    for my $t1 (@keys){
        if(ref($x->{$t1}) ne 'HASH'){
            # 子がHASHではないときはキーをリストとみなして処理終了
            my @tmp_arr = %$x;
            my @ret_arr;
            # @TODO map にしたいけどキーが奇数のときの対応が不明...
            # return map{[$_] if(defined($_))} %$x;
            for(@tmp_arr)
            {
                push(@ret_arr, [$_]) if $_;
            }

            return @ret_arr;
        }

        # 子孫がいるときは、子との組み合わせを返す
        my @child = parm($x->{$t1});
        for my $t2 (@child){
            push(@result, [$t1, @$t2]);
        }
    }

    return @result;
}

1;
