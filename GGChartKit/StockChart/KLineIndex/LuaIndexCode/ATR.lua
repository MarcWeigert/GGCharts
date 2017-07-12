
-- ATR 指标
-- @param list K线数组
-- @param getMethod 计算字段
-- @param param 24

function ATRIndex(aryList, getMethodHigh, getMethodLow, getMethodClose, param)
	
	funcRef = REF(getMethodClose, 1)
	funcMa = MA("tr", param)

	aryAtr = {}
	
	for i = 1, #aryList, 1 do
	
		t = math.max(aryList[i][getMethodHigh] - aryList[i][getMethodLow], math.abs(funcRef(i, aryList) - aryList[i][getMethodHigh]))
		b = math.abs(funcRef(i, aryList) - aryList[i][getMethodLow])
		
		aryAtr[i] = {tr = math.max(t, b)}
	end
	
	for i = 1, #aryAtr, 1 do
			
		aryAtr[i]["atr"] = funcMa(i, aryAtr)
	end
	
	return aryAtr
end