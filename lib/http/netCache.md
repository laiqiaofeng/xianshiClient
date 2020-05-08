在 dio中 options.extra是用来拓展参数的

|参数名|类型| 解释|
|-|-| - |
|refresh | bool |判断是否为下拉刷新， 如果是，本次请求不使用缓存，但是请求的结果依旧会缓存 |
|noCache|bool|是否要禁止缓存，如禁止，结果也不会缓存|
|list|bool|下拉刷新的对象是否是list|