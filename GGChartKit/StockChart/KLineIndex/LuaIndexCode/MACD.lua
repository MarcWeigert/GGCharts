-- BOLL 指标
-- @param list K线数组
-- @param getMethod 计算字段
-- @param param {SHORT = 12, LONG = 26, M = 9}
function MACDIndex(aryList, getMethod, param)

	aryMacdIndex = {}

	short = param["SHORT"]
	long = param["LONG"]
	m =param["M"]

	local funcEMAShort = EMA(getMethod, short, aryList)
	local funcEMALong = EMA(getMethod, long, aryList)

	for i = 1, #aryList, 1 do

		macd = {}
		macd["DIFF"] = funcEMAShort(i) - funcEMALong(i)
		aryMacdIndex[i] = macd
	end

	funcEMAM = EMA("DIFF", m, aryMacdIndex)

	for i = 1, #aryList, 1 do

		macd = aryMacdIndex[i]
		macd["DEA"] = funcEMAM(i)
	end

	for i = 1, #aryList, 1 do

		macd = aryMacdIndex[i]
		macd["STICK"] = 2 * (macd["DIFF"] - macd["DEA"])
	end

	return aryMacdIndex
end
