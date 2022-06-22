package site.mingsha.cicd.facade.impl;

import site.mingsha.cicd.facade.dto.TemplateRequestDTO;
import site.mingsha.cicd.facade.dto.TemplateResponseDTO;
import site.mingsha.cicd.facade.AbstractTemplateFacade;
import org.springframework.web.bind.annotation.*;

import site.mingsha.cicd.facade.TemplateFacade;

/**
 * @author chenlong
 * @date 2020-06-09
 */
@RestController
@RequestMapping("/template")
public class TemplateFacadeImpl extends AbstractTemplateFacade implements TemplateFacade {

    @PostMapping("/")
    @ResponseBody
    @Override
    public TemplateResponseDTO findById(@RequestBody TemplateRequestDTO requestDTO) {
        return TemplateResponseDTO.newInstance();
    }

    /* ------------------------------------------------------------------------------------------ */

    /**
     * module
     *
     * @return
     */
    @Override
    protected String module() {
        return "Template模块";
    }

}
