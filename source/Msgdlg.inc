{$ifdef ver100}
ButtonCaptions : array [0..10] of string = (
{$else}
ButtonCaptions : array [0..8] of string = (
{$endif}
  '是(&Y)',
  '否(&N)',
  '确定(&O)',
  '取消(&C)',
  '放弃(&b)',
  '重试(&R)',
  '忽略(&I)',
  '全部(&A)',
{$ifdef ver100}
  '全部都否(&t)',
  '全部都是(&l)',
{$endif}
  '&帮助'
);

DialogTitles : array [0..3] of string = (
  '警告',
  '错误',
  '信息',
  '确认'
);
