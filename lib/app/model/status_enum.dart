enum StatusEnum {
  init(1),
  progress(2),
  stoped(3),
  finish(4);

  const StatusEnum(this.value);
  final num value;
}
