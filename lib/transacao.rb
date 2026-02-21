require 'json'
require 'time'

class Transacao
  attr_reader :tipo, :valor, :metodo, :data, :saldo_anterior, :saldo_novo, :destino, :origem

  TIPOS_VALIDOS = %w[saque deposito transferencia_debito transferencia_credito]
  METODOS_VALIDOS = %w[dinheiro cheque pix ted doc]

  def initialize(tipo:, valor:, metodo:, saldo_anterior:, saldo_novo:, destino: nil, origem: nil)
    @tipo = tipo
    @valor = valor
    @metodo = metodo
    @data = Time.now
    @saldo_anterior = saldo_anterior
    @saldo_novo = saldo_novo
    @destino = destino
    @origem = origem
  end

  def to_hash
    {
      tipo: @tipo,
      valor: @valor,
      metodo: @metodo,
      data: @data.strftime('%d/%m/%Y %H:%M:%S'),
      saldo_anterior: @saldo_anterior,
      saldo_novo: @saldo_novo,
      destino: @destino,
      origem: @origem
    }
  end

  def self.from_hash(hash)
    new(
      tipo: hash['tipo'],
      valor: hash['valor'],
      metodo: hash['metodo'],
      saldo_anterior: hash['saldo_anterior'],
      saldo_novo: hash['saldo_novo'],
      destino: hash['destino'],
      origem: hash['origem']
    )
  end

  def descricao
    case @tipo
    when 'saque'
      "🔴 Saque de R$ #{format('%.2f', @valor)} via #{@metodo}"
    when 'deposito'
      "🟢 Depósito de R$ #{format('%.2f', @valor)} via #{@metodo}"
    when 'transferencia_debito'
      "🔵 Transferência enviada de R$ #{format('%.2f', @valor)} via #{@metodo}"
    when 'transferencia_credito'
      "🟣 Transferência recebida de R$ #{format('%.2f', @valor)} via #{@metodo}"
    end
  end

  def descricao_completa
    desc = descricao
    desc += "\n   → Destino: #{@destino}" if @destino
    desc += "\n   ← Origem: #{@origem}" if @origem
    desc
  end
end
