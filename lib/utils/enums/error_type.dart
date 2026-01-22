enum ErrorType {
  divisionByZero('Divisão por zero', 'Não é possível dividir por zero'),

  infinity('Número muito grande', 'O resultado excede o limite suportado'),

  notANumber('Valor inválido', 'A operação resultou em um valor inválido'),

  invalidNumber('Número inválido', 'O valor digitado não é um número válido'),

  overflow('Overflow', 'O número é grande demais para ser processado'),

  historyLoadError('Erro ao carregar', 'Não foi possível carregar o histórico'),

  historySaveError('Erro ao salvar', 'Não foi possível salvar o histórico'),

  historyClearError('Erro ao limpar', 'Não foi possível limpar o histórico'),

  corruptedData('Dados corrompidos', 'Os dados salvos estão corrompidos'),

  unknown('Erro', 'Ocorreu um erro inesperado')
  ;

  const ErrorType(this.shortMessage, this.fullMessage);

  final String shortMessage;

  final String fullMessage;
}
