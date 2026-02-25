require 'colorize'

class Validador
  def self.validar_cpf(cpf)
    cpf_numeros = cpf.gsub(/\D/, '')

    return { valido: false, erro: 'CPF deve ter 11 dígitos' } if cpf_numeros.length != 11

    return { valido: false, erro: 'CPF inválido' } if cpf_numeros.chars.uniq.length == 1

    { valido: true }
  end

  def self.validar_valor(valor)
    return { valido: false, erro: 'Valor deve ser maior que zero' } if valor <= 0

    return { valido: false, erro: 'Valor muito alto. Limite: R$ 1.000.000,00' } if valor > 1_000_000

    { valido: true }
  end

  def self.validar_senha(senha)
    return { valido: false, erro: 'Senha deve ter no mínimo 6 caracteres' } if senha.length < 6

    { valido: true }
  end

  def self.validar_metodo(metodo)
    metodos_validos = %w[dinheiro cheque pix ted doc]

    unless metodos_validos.include?(metodo.downcase)
      return {
        valido: false,
        erro: "Método inválido. Escolha: #{metodos_validos.join(', ')}"
      }
    end

    { valido: true }
  end

  def self.validar_metodo_transferencia(metodo)
    metodos_validos = %w[pix ted doc]

    unless metodos_validos.include?(metodo.downcase)
      return {
        valido: false,
        erro: "Método inválido para transferência. Use: #{metodos_validos.join(', ')}"
      }
    end

    { valido: true }
  end

  def self.formatar_cpf(cpf)
    cpf = cpf.gsub(/\D/, '')
    "#{cpf[0..2]}.#{cpf[3..5]}.#{cpf[6..8]}-#{cpf[9..10]}"
  end

  def self.gerar_numero_conta
    agencia = rand(1000..9999)
    conta = rand(10_000..99_999)
    digito = rand(0..9)
    "#{agencia}-#{conta}-#{digito}"
  end

  def self.validar_numero_conta(numero)
    padrao = /^\d{4}-\d{5}-\d$/

    unless numero.match?(padrao)
      return {
        valido: false,
        erro: 'Formato de conta inválido. Use: 1234-12345-6'
      }
    end

    { valido: true }
  end
end
