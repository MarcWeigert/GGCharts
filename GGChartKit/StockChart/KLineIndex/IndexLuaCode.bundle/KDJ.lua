-- KDJ 指标
-- @param list K线数组
-- @param getMethod 计算字段
-- @param param {n = 9, m1 = 3, m2 = 3}

function KDJIndex(aryList, getLowMethod, getHighMethod, getCloseMethod, param)

	kdjArray = {}
	rsvArray = {}

	funcLLV = LLV(getLowMethod, param["n"], aryList)
	funcHHV = HHV(getHighMethod, param["n"], aryList)

	for i = 1, #aryList, 1 do

        local d = (funcHHV(i) - funcLLV(i)) * 100

        if (d == 0) then

            d = 1
        end

		rsvArray[i] = {rsv = (aryList[i][getCloseMethod] - funcLLV(i)) / d}
	end

	funcSMA = SMA("rsv", param["m1"], 1, rsvArray)

	for i = 1, #rsvArray, 1 do

		kdjArray[i] = {k = funcSMA(i)}
	end

	funcSMA2 = SMA("k", param["m2"], 1, kdjArray)

	for i = 1, #kdjArray, 1 do

		kdjArray[i]["d"] = funcSMA2(i)
		kdjArray[i]["j"] = 3 * kdjArray[i]["k"] - 2 * kdjArray[i]["d"]
	end

	return kdjArray
end
