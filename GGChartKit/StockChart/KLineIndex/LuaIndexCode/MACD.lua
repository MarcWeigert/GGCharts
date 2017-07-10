-- BOLL 指标
-- @param list K线数组
-- @param getMethod 计算字段
-- @param param {SHORT = 12, LONG = 26, M = 9}
function MACDIndex(aryList, getMethod, param)

	aryMacdIndex = {}
	
	short = param["SHORT"]
	long = param["LONG"]
	m = param["M"]
	
	funcEMAShort = EMA(getMethod, short)
	funcEMALong = EMA(getMethod, long)
	funcEMAM = EMA("DIFF", m)
	
	for i = 1, #aryList, 1 do
	
		macd = {}
		macd["DIFF"] = funcEMAShort(i, aryList) - funcEMALong(i, aryList)
		aryMacdIndex[i] = macd
	end
	
	for i = 1, #aryList, 1 do
		
		macd = aryMacdIndex[i]
		macd["DEA"] = funcEMAM(i, aryMacdIndex)
	end
	
	for i = 1, #aryList, 1 do
		
		macd = aryMacdIndex[i]
		macd["STICK"] = 2 * (macd["DIFF"] - macd["DEA"])
	end
	
	return aryMacdIndex
end
