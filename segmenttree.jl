struct segtree{T}
    memory :: Vector{T}
    op :: Function
    e :: T
    size :: Integer
    function segtree{T}(data :: Vector{T}, op :: Function,e :: T) where T
        size = 1
        # 完全二分木を使うのでNより大きな2ᵇⁱᵗを探す
        N = length(data)
        while N > size
            size <<= 1 
        end
        # memoryを作る
        memory = fill(e,2size) #最初の2ᵇⁱᵗ-1個のメモリは親
        offset = size-1
        # dataを代入
        for n in 1:N
            memory[offset+n] = data[n]
        end
        # 初期化
        for i in offset:-1:1
            memory[i] = op(memory[2i],memory[2i+1])
        end
        new{T}(memory,op,e,size)
    end
end
segtree(data,op,e) = segtree{typeof(e)}(data,op,e) 
# 元データのdata[idx]に対応する部分をvalueに変更
function set!(S::segtree,idx,value) 
    idx += S.size-1 # offsetの替わり
    S.memory[idx] = value
    while idx > 1
        idx >>= 1
        S.memory[idx] = S.op( S.memory[2idx],S.memory[2idx+1])
    end
end
# 元データのdata[idx]に対応する値を出力
function get(S::segtree,idx) 
    idx += S.size-1 # offsetの替わり
    return S.memory[idx]
end
"""
    prod(S::segtree,l,r)
    区間lからrまでの積を表示
"""
function prod(S::segtree,l,r)
    sml, smr = S.e, S.e
       
    l += S.size-1
    r += S.size

    # 未計算の区間がなくなるまで
    while l < r
        # 自身が右子ノードなら使用
        if isodd(l)
            sml = S.op(sml, S.memory[l])
            l += 1
        end
        if isodd(r)
            r -= 1
            smr = S.op(S.memory[r], smr)
        end
        # 親に移動
        l >>= 1
        r >>= 1
    end
    return S.op(sml, smr)
end
function allprod(S::segtree,L,R)
    return S.memory[1]
end

# f(op(data[1],…,data[r-1])) = true
# となる最大のrを探す
# ACLのmax_rightに対応
function searchlast(S::segtree,l,f)
    l += S.size-1 #葉に移動
    sm = S.e #fがtrueとなると確定した領域の積(op=maxなら最大値が入る)
    while true # 無限ループ　答えが見つかればbreakで抜ける
        # 根ノードか、右子ノードにつくまで親に行く
        # 右子ノードの親にはlより小さいノードの情動が入る
        while iseven(l)
            l >>= 1
        end
        if f(S.op(sm,S.memory[l]))
            # S.memory[l]がカバーする領域ではop(data[l],…)=true
            # falseとなるrは右側のノードにある
            sm = S.op(sm,S.memory[l]) # lまでは確定
            l += 1
        else
            # S.memory[l]がカバーする領域ではop(data[l],…)=false
            # falseとなるrはこの領域の何処か
            while l < S.size # 葉ノードに子はいない
                l <<= 1 # 左子ノードに移動
                if f(S.op(sm,S.memory[l]))
                    # 今いるノード(左側)の葉にrはいない
                    sm = S.op(sm,S.memory[l]) 
                    l += 1 #右側に行く
                else
                    # 今いるノード(左側)の葉にrがいる
                    # 次のwhileのループで子に移動
                end 
            end
            return l-(S.size-1)
        end
        if (l & -l) == l
            # 1,3,…,2ᵏ-1の時にはl以上が全てtrue
            break
        end
    end
    return 2S.size
end
# f(op(data[1],…,data[r-1])) = true
# となる最小のlを探す
# ACLのmin_leftに対応
# searchlastの右が左になる
function searchfirst(S::segtree,r,f)
    r += S.size-1 #葉に移動
    sm = S.e #fがtrueとなると確定した領域の積(op=maxなら最大値が入る)
    while true # 無限ループ　答えが見つかればbreakで抜ける
        # 根ノードか、右子ノードにつくまで親に行く
        # 右子ノードの親にはlより小さいノードの情動が入る
        while iseven(r)
            r >>= 1
        end

        if f(S.op(sm,S.memory[r]))
            # S.memory[r]がカバーする領域ではop(data[r],…)=true
            # falseとなるrは右側のノードにある
            sm = S.op(sm,S.memory[r]) # lまでは確定
            r -= 1
        else
            # S.memory[r]がカバーする領域ではop(data[r],…)=false
            # falseとなるrはこの領域の何処か
            while r < size # 葉ノードに子はいない
                r = 2r+1 # 右子ノードに移動
                if f(s.op(sm,S.memory[r]))
                    # 今いるノード(右側)の葉にrはいない
                    sm = S.op(sm,S.memory[r]) 
                    r -= 1 #左側に行く
                else
                    # 今いるノード(右側)の葉にrがいる
                    # 次のwhileのループで子に移動
                end 
            end
            return r-(S.size-1)
        end
        if (r & -r) == r
            break
        end
    end
    return 0
end