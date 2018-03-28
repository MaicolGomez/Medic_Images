/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package read.dicom.view;

import java.awt.Graphics;
import java.awt.Image;
import javax.swing.JPanel;

/**
 *
 * @author Adriano
 */
public class PanelImagen extends JPanel {

    private Image bgImage;

    public PanelImagen() {
        super();
        // Hacemos que el panel sea transparente
        this.setOpaque(false);
    }

    /**
     * Lo utilizaremos para establecerle su imagen de fondo.
     *
     * @param bgImage La imagen en cuestion
     */
    public void setBackgroundImage(Image bgImage) {
        this.bgImage = bgImage;
    }

    @Override
    public void paint(Graphics g) {
        // Pintamos la imagen
        if (bgImage != null) {
            g.drawImage(bgImage, 0, 0, null);
        }
        // Y pintamos el resto de cosas que pueda tener el panel
        super.paint(g);
    }
}
