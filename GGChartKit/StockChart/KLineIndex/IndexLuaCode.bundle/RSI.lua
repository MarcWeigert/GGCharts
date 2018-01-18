-- RSI 指标
-- @param list K线数组
-- @param getMethod 计算字段
-- @param param {6, 12, 24}

function RSIIndex(aryList, getMethod, param)

	mabArray = {}
	risArray = {}

	funcREF = REF(getMethod, 1, aryList)

	for i = 1, #aryList, 1 do

		mabArray[i] = {max = math.max(aryList[i][getMethod] - funcREF(i), 0), abs = math.abs(aryList[i][getMethod] - funcREF(i))}
	end

	for i = 1, #param, 1 do

		number = param[i]
		aryRsiN = {}

		funcSMAMax = SMA("max", number, 1, mabArray)
		funcSMAAbs = SMA("abs", number, 1, mabArray)

		for j = 1, #aryList, 1 do

			t = funcSMAMax(j)
			b = funcSMAAbs(j)

			if b == 0 then

				b = 1
			end

			aryRsiN[j] = t / b * 100
		end

		risArray[i] = aryRsiN
	end

	titles = {}

	for i = 1, #param, 1 do

		titles[i] = "RSI"..param[i];
	end

	aryIndex = {}

	for i = 1, #aryList, 1 do

		rsi = {}

		for j = 1, #titles, 1 do

			aryRsiN = risArray[j]
			rsi[titles[j]] = aryRsiN[i]
		end

		aryIndex[i] = rsi
	end

	return aryIndex
end
