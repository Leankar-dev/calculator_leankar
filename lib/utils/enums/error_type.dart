/// Tipos de erro que podem ocorrer na calculadora
enum ErrorType {
  /// Divisão por zero
  divisionByZero('Divisão por zero', 'Não é possível dividir por zero'),

  /// Resultado infinito ou muito grande
  infinity('Número muito grande', 'O resultado excede o limite suportado'),

  /// Resultado não é um número válido (NaN)
  notANumber('Valor inválido', 'A operação resultou em um valor inválido'),

  /// Erro ao fazer parse de número
  invalidNumber('Número inválido', 'O valor digitado não é um número válido'),

  /// Erro de overflow (número muito grande)
  overflow('Overflow', 'O número é grande demais para ser processado'),

  /// Erro ao carregar histórico
  historyLoadError(
      'Erro ao carregar', 'Não foi possível carregar o histórico'),

  /// Erro ao salvar histórico
  historySaveError('Erro ao salvar', 'Não foi possível salvar o histórico'),

  /// Erro ao limpar histórico
  historyClearError('Erro ao limpar', 'Não foi possível limpar o histórico'),

  /// Dados corrompidos no storage
  corruptedData('Dados corrompidos', 'Os dados salvos estão corrompidos'),

  /// Erro genérico/desconhecido
  unknown('Erro', 'Ocorreu um erro inesperado');

  const ErrorType(this.shortMessage, this.fullMessage);

  /// Mensagem curta para exibir no display
  final String shortMessage;

  /// Mensagem completa para logs ou detalhes
  final String fullMessage;
}
