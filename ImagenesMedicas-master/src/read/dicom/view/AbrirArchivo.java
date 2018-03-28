/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package read.dicom.view;

import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JPanel;
import javax.swing.filechooser.FileNameExtensionFilter;

/**
 *
 * @author Adriano
 */
public class AbrirArchivo extends JPanel implements ActionListener {
    
    private JFileChooser fileChooser;
    
    public AbrirArchivo(){
        super(new BorderLayout());
        
        JButton btnEnviar = new JButton("Agregar...");
        btnEnviar.addActionListener(this);
        add(btnEnviar,BorderLayout.CENTER);
        
        //System.out.println("Constructor");
    }
    
    @Override
    public void actionPerformed(ActionEvent e){
        if (fileChooser==null){
            fileChooser = new JFileChooser();
            fileChooser.addChoosableFileFilter(new FileNameExtensionFilter("Imagenes DICOM", "dcm"));
            fileChooser.setAcceptAllFileFilterUsed(false);
        }
        
        int returnEval = fileChooser.showDialog(AbrirArchivo.this, "Agregar");
        
        if (returnEval == JFileChooser.APPROVE_OPTION){
            File file = fileChooser.getSelectedFile();
            //System.out.println("Agrendo Archivo:"+file.getName());
        }else{
            //System.out.println("El usuario cancelo la subida de la imagen");
        }
        
        fileChooser.setSelectedFile(null);
    }
}
