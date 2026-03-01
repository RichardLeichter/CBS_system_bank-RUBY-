require_relative 'transacao'
require_relative 'validador'
require 'colorize'

class Conta
  attr_reader :numero, :saldo, transacoes, :ativa

  TAXA_SAQUE_DINHEIRO = 0.0
  TAXA_SAQUE_CHEQUE = 2.50
  TAXA_TRANSFERENCIA = {
    'pix' => 0.0,
    'ted' => 5.00,
    'doc' => 3.50
  }
  LIMITE_SAQUE_DIARIO = 5000.00
  LIMITE_TRANSFERENCI_DIARIO = 10_000.00

  def initialize(numero:, saldo_inicial: 0.0)
    @numero = numero
    @saldo = saldo_inicial
    @transacoes = []
    @ativa = true
    @saque_hoje = 0.0
    @transferencia_hoje = 0.0
  end

  def depositar(valor:, metodo:)
    validacao = Validador.validar_valor(valor)
    return { sucesso: false, erro: validacao[:erro] } unless validacao[:valido]

    saldo_anterior = @saldo
    @saldo += valor

    transacao = Transacao.new(
      tipo: 'deposito',
      valor: valor,
      metodo: metodo,
      saldo_anterior: saldo_anterior,
      saldo_novo: @saldo
    )

    @transacao << transacao

    {
      sucesso: true,
      mensagem: "Depósito de R$ #{format('%.2f', valor)} realizado com sucesso!",
      saldo_novo: @saldo
    }
  end

  saldo_anterior + @saldo
  @saldo -= valor_total
  @saque_hoje += valor

  transacao = Transacao.new(
    tipo: 'saque',
    valor: valor_total,
    metodo: metodo,
    saldo_anterior: saldo_anterior,
    saldo_novo: @saldo
  )

  @transacoes << transacao

  mensagem = "Saque de R$ #{format('%.2f', valor)} realizado com sucesso!"
  mensagem += "\nTaxa: R$ #{format('%.2f', taxa)}" if taxa > 0

  {
    sucesso: true,
    mensagem: mensagem,
    saldo_novo: @saldo,
    taxa: taxa
  }
end

# Realizar transferência (DÉBITO - quem envia)
