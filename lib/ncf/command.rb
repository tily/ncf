# coding:utf-8
require 'thor'
require 'json'
require 'ncf/client'

module Ncf
	class Command < ::Thor
		desc 'exec /path/to/template.json', 'JSON テンプレートを実行します'
		def exec(path)
			validate_env
			if !File.exists?(path)
				abort "ファイルが存在しません: #{path}"
			end
			json = File.read(path)
			response = nil
			begin
				response = client.execute_stack(json)
			rescue Ncf::Client::ResponseError => e
				abort "ResponseError: #{e}"
			end
			exec_id = response['ExecuteStackResponse']['ExecuteStackResult']['ExecutionId']
			status = nil
			File.write('exec_id.txt', exec_id)
			loop do
				response = client.describe_stack(exec_id)
				status = response['DescribeStackResponse']['DescribeStackResult']['StackStatus']
				puts "処理中です"
				break if status != 'EXECUTE_IN_PROGRESS'
				sleep 5
			end
			if status == 'EXECUTE_COMPLETE'
				puts "処理が正常終了しました"
			else
				puts "処理が異常終了しました"
			end
		end

		desc 'desc', '実行状況を確認します (exec コマンドで書き出される request_id.txt が必要です)'
		def desc
			validate_env
			if !File.exists?('exec_id.txt')
				abort "最初に exec を実行してください"
			end
			exec_id = File.read('exec_id.txt').chomp
			response = client.describe_stack(exec_id)
			status = response['DescribeStackResponse']['DescribeStackResult']['StackStatus']
			reason = response['DescribeStackResponse']['DescribeStackResult']['StackStatusReason']
			case status
			when 'EXECUTE_IN_PROGRESS'; puts "前回の処理が実行中です"
			when 'EXECUTE_COMPLETE'; puts "前回の処理が正常終了しました"
			else puts "前回の処理が異常終了しました (#{reason})"
			end
		end

		no_commands do
			def validate_env
				keys = ['NCF_ACCESS_KEY_ID', 'NCF_SECRET_ACCESS_KEY', 'NCF_ENDPOINT']
				if keys.any? {|x| ENV[x].nil? }
					abort "環境変数 #{keys.join(',')} のすべてを設定してください"
				end
			end

			def client
				@client ||= Ncf::Client.new(
					access_key_id_key: 'AccessKeyId',
					access_key_id: ENV['NCF_ACCESS_KEY_ID'],
					secret_access_key: ENV['NCF_SECRET_ACCESS_KEY'],
					endpoint: ENV['NCF_ENDPOINT']
				)
			end
		end
	end
end
