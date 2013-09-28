module Datum
  class OperationHelpers
    DELETE = "delete"
    CREATE = "create"
    REMOVE = "remove"

    def colorize(text, color_code); "\e[#{color_code}m#{text}\e[0m"; end
    def red(text); colorize(text, 31); end
    def green(text); colorize(text, 32); end
    def file_msg(msg); puts "      #{msg}"; end

    # given the src (eg /foo) copy the tree below to destination (eg /bar)
    # so that /foo/goo becomes /bar/goo
    # .delete signals files to remove
    # .hidden signals files to move, rename (eg gitignore.hidden => .gitignore)
    def copy_from src, destination
      puts ""
      file_msg " root   #{destination}"
      Dir.glob("#{src}/**/*").each {|x|
        
        target = copy_from_file_helpers(x.split("#{src}/")[1])
        target.is_a?(String) ? 
          copy_file_from(x, destination, target) : 
          delete_file_from(x, destination, target[:to_delete])
      }
      puts ""
    end


private
    # conventions for moving files:
    #   + if files are 'hidden' (e.g. .gitignore) name them [filename.hidden]
    #     this will result in: .filename
    #
    #   + if files are to be deleted (e.g. rails.png) name them 
    #     [filename.ext.delete] this will result in filename.ext with the 
    #     proper return type for a delete flow
    #
    #   + if files to copy are getting hit by some sort of extension-based
    #     error / warning (e.g. ri / RDoc) - use can mask the extension with
    #     .xx - [filename.rb.xx] which will yield [filename.rb]
    def copy_from_file_helpers f
      if f.end_with? ".hidden"
        str = ("." + f.split("/").last.sub(".hidden", ""))
        return (f.scan(
          p = /\/(?:.(?!\/))+$/).count != 0 ? f.sub(p, "\/" + str) : str)
      end
      return f.sub(".xx", "") if f.end_with? ".xx"
      return {:to_delete => f.sub(".delete", "")} if f.end_with? ".delete"
      return f
    end

    def finalize_local_file src, des, local_path, is_delete = false
      final_file = "#{des}/#{local_path}"
      
      unless File.directory?(src)
        delete_file final_file, local_path
        file_msg(is_delete ? "#{red(DELETE)}  #{local_path}" : 
          "#{green(CREATE)}  #{local_path}")
        return final_file
      else
        FileUtils.mkdir_p final_file # ensure local directory is present
      end
      return nil
    end

    def delete_file_from src, des, local_path
      final_file = finalize_local_file src, des, local_path, true
      # if the file exists locally - finalize_local_file will delete it... 
    end

    def copy_file_from src, des, local_path
      final_file = finalize_local_file src, des, local_path
      copy_file src, final_file unless final_file.nil?
    end

    def copy_file src, des
      FileUtils.cp_r src, des
    end

    def delete_file src, local_path = nil
      if(File.exists?(src))
        FileUtils.remove_file(src) 
        file_msg("#{red(REMOVE)}  #{local_path}") unless local_path.nil?
      end
    end
  end
end