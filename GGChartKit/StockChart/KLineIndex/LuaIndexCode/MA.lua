
-- MA(X, N) 求X在N个周期内的简单移动平均

function MA(getMethod, sub)

	return function (index, aryKLine)

		local sum = 0

		if (sub > index) then

			return "1.175494351e-38F"
		end

		for i = 1, sub, 1 do

			sum = sum + aryKLine[index][getMethod]
			index = index - 1
		end

	return sum / sub
	end
end

-- 数据周期内平均和
-- @param array 数据数组
-- @param size 数组长度
-- @param get 求和字段
-- @param day 周期
-- @return list FLT_MIN 代表空

function MAIndex(aryList, size, getMethod, day)

	MAArray = {}
	MAMethod = MA(getMethod, day)

	for i = 1, size, 1 do

	MAArray[i] = MAMethod(i, aryList)
	end

	return MAArray
end
