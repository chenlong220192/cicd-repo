package site.mingsha.cicd.facade;

import site.mingsha.cicd.facade.dto.TemplateRequestDTO;
import site.mingsha.cicd.facade.dto.TemplateResponseDTO;
import org.springframework.web.bind.annotation.*;

/**
 * @author chenlong
 * @date 2020-06-09
 */
public interface TemplateFacade {

    /**
     * template
     *
     * @param requestDTO
     * @return
     */
    TemplateResponseDTO findById(@RequestBody TemplateRequestDTO requestDTO);

}
